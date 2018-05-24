class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
    end
  end

  def get_referral
    referral = params[:referral]
    order_id = params[:order_id]
    name = params[:first_name].to_s + " " + params[:last_name].to_s
    user = User.where(referral: referral).first
    if user.present?
      ReferralSale.create(user_id: user.id, order_id: order_id, name: name, email: params[:email],
                          address: params[:address], shopdomain: params[:shopdomain], price: params[:price])
    end
    render json: {success: true}
  end

end
