class Api::CookiesController < ApplicationController

  def index
    cookie_time = Setting.first.cookie_time
    render json: {cookie_time: cookie_time}
  end

end
