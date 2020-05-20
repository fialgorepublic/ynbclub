class Api::CookiesController < ApplicationController
  skip_before_action :block_banned_users

  def index
    cookie_time = Setting.first.cookie_time
    render json: {cookie_time: cookie_time}
  end

end
