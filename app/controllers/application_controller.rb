class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_variables

  def set_variables
    @shopify_domain = "test-saint.myshopify.com"
    @token = "f3646fea1b5bacf9021656e656d1c252"
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

end
