class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_variables
  before_action :allow_iframe_requests
  before_action :allow_user_request

  def set_variables
    @shopify_domain = "saint-messanger.myshopify.com"
    @token = "881f47d0a2db78212645e4f33f5fefe8"
  end

  def after_sign_up_path(resource)
    dashboard_path # after sign_up redirect to dashboard path
  end

  def after_sign_in_path_for(resource)
    dashboard_path # normal app users go to dashboard path
  end

  def initiate_shopify_session
    @session = ShopifyAPI::Session.new(@shopify_domain, @token)
    ShopifyAPI::Base.activate_session(@session)
  end

  def clear_shopify_session
    ShopifyAPI::Base.clear_session
  end

  private

  def allow_user_request
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

end
