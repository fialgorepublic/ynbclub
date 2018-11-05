# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # super
    redirect_to root_path
  end

  # POST /resource/sign_in
  def create
    resource = User.where(email: params[:resource][:email].downcase).first
    if resource.present? && resource.valid_password?(params[:resource][:password]) # validate user password
      resource.update_attributes(is_shopify_user: false)
      sign_in :user, resource
      flash[:notice] = "Successfully logged in"
      redirect_to dashboard_path
    else
      flash[:alert] = "Authentication failed"
      redirect_to root_path
    end
    # super
  end
  def destroy
    super
    flash.delete(:notice)
  end
  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
