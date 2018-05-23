class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to dashboard_path
    else
    end
  end

  def get_referral
    puts "------------------- referral is here ---------------------",params.inspect
    render json: {success: true}
  end

end
