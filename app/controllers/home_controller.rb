class HomeController < ApplicationController
  include ApplicationHelper
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
    end
  end

  def get_referral
    initiate_shopify_session
    referral = params[:referral]
    order_id = params[:order_id]
    name = params[:first_name].to_s + " " + params[:last_name].to_s
    customer_id = params[:customer_id]
    user = User.where(referral: referral).first
    order_no = ShopifyAPI::Order.find(order_id).name
    if ReferralSale.find_by_order_no(order_no).blank?
      if user.present?
        customers = Customer.where(email: params[:email])
        if customers.count > 1
          customers.each { |cus| cus.delete }
          customer =  Customer.create(email: params[:email])
        else
          customer = customers.present? ? customers.first : Customer.create(email: params[:email])
        end

        customer.update_attributes(name: name, customer_id: customer_id)

        ReferralSale.create(user_id: user.id, order_id: order_id, name: name, email: params[:email],
                            address: params[:address], shopdomain: params[:shopdomain], price: params[:price], order_no: order_no)
        insert_points(user.id, 2, "", nil, order_no)
        UserMailer.referral_sale(user, name, params[:shopdomain]).deliver
      end
    end
    clear_shopify_session
    render json: {success: true}
  end

  def sign_in_user
    user = User.includes(:points, :profile).with_attached_avatar.find_by_email(params[:user][:email])
    if user.present?
      if !user.banned?
        if user.valid_password?(params[:user][:password])
          path = params[:redirect].present? ? blogs_path : dashboard_path
          sign_in :user, user

          flash[:notice] = I18n.t(:login_success)
          render json: { success: true, message: I18n.t(:login_success), path: path }
        else
          flash[:alert] = I18n.t(:email_password_invalid)
          render json: {success: false, message: I18n.t(:email_password_invalid)}
        end
      else
        render json: {success: false, message: I18n.t(:banned_message)}
      end
    else
      flash[:alert] = I18n.t(:email_password_invalid)
      render json: {success: false, message: I18n.t(:email_password_invalid) }
    end
  end

  def set_default_language
    I18n.default_locale = params[:locale]
    redirect_to root_path
  end
end
