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
    customer_id = params[:customer_id]
    user = User.where(referral: referral).first
    if user.present?
      customer = Customer.create(name: name, email: params[:email], customer_id: customer_id)
      ReferralSale.create(user_id: user.id, order_id: order_id, name: name, email: params[:email],
                          address: params[:address], shopdomain: params[:shopdomain], price: params[:price])
      point_type = PointType.where(name: "Your product was ordered ").first
      Point.create(user_id: user.id, point_type_id: point_type.id, point_value: point_type.point)
    end
    render json: {success: true}
  end

end
