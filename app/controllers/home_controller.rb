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
    user = User.find_by_email(params[:user][:email])
    if user.present?
      if !user.banned?
        if user.valid_password?(params[:user][:password])
          sign_in :user, user
          flash[:notice] = "Successfully login"
          render json: {success: true, message: "Successfully login"}
        else
          flash[:alert] = "Email and password invalid"
          render json: {success: false, message: "Email and password invalid"}
        end
      else
        render json: {success: false, message: "You are banned from admin"}
      end
    else
      flash[:alert] = "Email and password invalid"
      render json: {success: false, message: "Email and password invalid"}
    end
  end

end
