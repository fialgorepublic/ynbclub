class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  before_action :set_variables
  before_action :allow_iframe_requests
  before_action :allow_user_request
  before_action :blog_not_found
  before_action :set_earn_coin
  before_action :set_page
  before_action :set_snapshot

  def set_variables
    @shopify_domain = "saintlbeau.myshopify.com"
    @token = "65f08aa2bc5386c55298ed566ad18ccd"
  end

  def after_sign_up_path(resource)
    dashboard_path # after sign_up redirect to dashboard path
  end

  def after_sign_in_path_for(resource)
    dashboard_path # normal app users go to dashboard path
  end

  def initiate_shopify_session
      @session = ShopifyAPI::Session.new("saintlbeau.myshopify.com", "65f08aa2bc5386c55298ed566ad18ccd")
    ShopifyAPI::Base.activate_session(@session)
  end

  def clear_shopify_session
    ShopifyAPI::Base.clear_session
  end

  def with_format(format, &block)
    old_formats = formats
    self.formats = [format]
    block.call
    self.formats = old_formats
    nil
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

  def blog_not_found
    return unless user_signed_in?
    return if params[:blog_not_found].blank?

    return redirect_to buyerDashboard_path(blog_not_found: true) if controller_name == "home" && current_user.is_buyer?
    redirect_to dashboard_path(blog_not_found: true) if controller_name == "home"
  end

  def set_earn_coin
    @earn_coin = EarnCoin.first
    @earn_coin.point_types
  end

  def set_page
    @page = Page.first || Page.create(heading: "Who are we?", sub_heading: "")
  end

  def set_snapshot
    @page = Snapshot.first || Snapshot.create(step1_text: "Make selfie photo or video with product bought on your mobile", step2_text: "Upload to facebook , twitter or intstagram and copy link to your post, Don't forget to add a hashtag #saintlbeau",
                                      step3_text: "Insert copied link to the special field on the web site", step4_text: "Confirm and receive 20 coins!")
  end
end
