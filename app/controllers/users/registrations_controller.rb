# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    resource = User.new(sign_up_params)
    if params[:resource][:reference_no].present?
      resource.reference_no = SecureRandom.hex(5)
    end
    resource.referral = Devise.friendly_token
    if resource.save
      if params[:invite].present?
        user_invited = User.find_by_email(params[:invite])
        if user_invited
          insert_points(user_invited.id, 6, "Invitation accepted by #{resource.name}")
          insert_points(resource.id, 6, "Accepted the invitation of #{user_invited.name}")
          UserMailer.referral_sign_up(user_invited, resource).deliver
        end
      end
      begin
      UserMailer.user_sign_up(resource).deliver
      SubscribeUserToMailchimp.perform_later(resource)
      rescue
      end
      begin
        initiate_shopify_session
        customers = ShopifyAPI::Customer.all(:params => {:page => 1, :limit => 250}, query: {fields: %w(id email).join(',')})
        customer = customers.detect { |c| c.email == "#{resource.email}" }
        if customer.nil?
          customer = ShopifyAPI::Customer.new
          customer.email = "#{resource.email}"
          customer.first_name = resource.name
          customer.last_name = ''
          customer.save
        end
        clear_shopify_session
      rescue
      end
      sign_in :user, resource
      flash[:notice] = "Successfully Signed Up"
      render json: { success: true }
    else
      @error_messages =[]
      resource.errors.full_messages.map { |msg|      # Show Error messages while sign_up user
        @error_messages << msg
      }
      render json: { success: false, message: @error_messages[0] }
    end

    # super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def sign_up_params
    params.require(:resource).permit(:name, :email, :password, :reference_no)
  end

end
