class HomeController < ApplicationController
  include ApplicationHelper
  def index
    # if (params[:is_shopify].present? && params[:is_shopify].to_s == "true")
    #   user = User.find_by_email(params[:email])
    #   if user
    #     user.update_attributes(is_shopify_user: true)
    #     sign_in :user, user
    #   else
    #     role = Role.find_by_name('Admin')
    #     user = User.create(name: params[:name], email: params[:email], password: Devise.friendly_token,
    #                        social_login: false, is_shopify_user: true, role_id: role.id)
    #     user.create_profile
    #     sign_in :user, user
    #   end
    #   redirect_to users_path
    # else
    #   if user_signed_in?
    #     redirect_to dashboard_path
    #   else
    #   end
    # end
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
    if user.present?
      customer = Customer.create(name: name, email: params[:email], customer_id: customer_id)
      ReferralSale.create(user_id: user.id, order_id: order_id, name: name, email: params[:email],
                          address: params[:address], shopdomain: params[:shopdomain], price: params[:price], order_no: order_no)
      insert_points(user.id, 2)
      UserMailer.referral_sale(user, name, params[:shopdomain]).deliver
    end
    clear_shopify_session
    render json: {success: true}
  end

  def sign_in_user
    user = User.find_by_email(params[:user][:email])
    if user.present?
      if user.valid_password?(params[:user][:password])
        sign_in :user, user
        flash[:notice] = "Successfully login"
        render json: {success: true, message: "Successfully login"}
      else
        flash[:alert] = "Email and password invalid"
        render json: {success: false, message: "Email and password invalid"}
      end
    else
      flash[:alert] = "Email and password invalid"
      render json: {success: false, message: "Email and password invalid"}
    end
  end

end
