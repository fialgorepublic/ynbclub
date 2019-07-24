class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  before_action :allow_iframe_requests
  before_action :allow_user_request
  before_action :blog_not_found
  before_action :set_earn_coin
  before_action :set_page
  before_action :get_share_with_friend
  before_action :set_snapshot
  before_action :redirect_to_blogs, if: :shopify_redirected?
  before_action :set_locale

  def set_locale
    I18n.locale = Rails.env.development? ? :en : params[:locale] || I18n.default_locale
  end

  def after_sign_up_path(resource)
    dashboard_path # after sign_up redirect to dashboard path
  end

  def after_sign_in_path_for(resource)
    dashboard_path # normal app users go to dashboard path
  end

  def initiate_shopify_session
    shopify_session = ShopifyAPI::Session.new(domain: "saintlbeau.myshopify.com", token: 'b8a6f6c3187c79cd975c9bde50c12756', api_version: '2019-04')
    ShopifyAPI::Base.activate_session(shopify_session)
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
    return if current_user.blank?
    return if params[:blog_not_found].blank?

    return redirect_to buyerDashboard_path(blog_not_found: true) if controller_name == "home" && current_user.is_buyer?
    redirect_to dashboard_path(blog_not_found: true) if controller_name == "home"
  end

  def set_earn_coin
    @earn_coin = EarnCoin.first
    @earn_coin.point_types
  end

  def set_page
    @page = Page.with_attached_image.first || Page.create(heading: "Who are we?", sub_heading: "")
  end

  def set_snapshot
    @snapshot = Snapshot.first || Snapshot.create(step1_text: "Make selfie photo or video with product bought on your mobile", step2_text: "Upload to facebook , twitter or intstagram and copy link to your post, Don't forget to add a hashtag #saintlbeau",
                                      step3_text: "Insert copied link to the special field on the web site", step4_text: "Confirm and receive 20 coins!")
  end

  def shopify_redirected?
    params[:shopify_blog_redirected].present?
  end

  def redirect_to_blogs
    redirect_to blogs_path if user_signed_in?
  end

  def get_share_with_friend
    @share_with_friends = ShareWithFriend.first || create_new
  end

  def create_new
    ShareWithFriend.create(reward_text: "You'll receive #{get_point(6)} coins on the saint l' Beau web site for every registered friend by your invitation link. your friend will receive #{get_point(6)}  coins too",
                          earn_coins_text: "How can I earn and spend coins?", fb_btn_text: "Share on facebook", twitter_btn_text: "Share on Twitter", email_btn_text: "Share on Mail")
  end

  def authorize_user!
    unless user_has_permission?
      flash[:alert] = 'You are not authorized for this resource.'
      redirect_to dashboard_path
    end
  end

  def user_has_permission?
    return true if current_user.is_admin? #for admin user
    return false if controller_name == "permissions"
    return false if controller_name == "shared_urls"
    user_has_permissions?
  end

  def user_has_permissions?
    return permission_exists?(action_name, controller_name) if action_name == "approve_sales" && controller_name == "referral_sales"
    return permission_exists?('manage_rewards', 'point_types') if controller_name == "point_types"
    return permission_exists?('configurations', 'settings') if controller_name == "settings"
    return permission_exists?(action_name, controller_name) if action_name == "ban" && controller_name == "users"
    return permission_exists?(action_name, controller_name) if action_name == "deduct_points" && controller_name == "users"
    return permission_exists?(action_name, controller_name) if action_name == "brand_ambassadors" && controller_name == "users"
    return permission_exists?('ambassadors', 'users') if action_name == "index" && controller_name == "users"
    return permission_exists?('index', controller_name) if controller_name == "payments"
    return permission_exists?('categories', controller_name) if controller_name == "categories"
    return permission_exists?('page_design', 'dashboard') if ['pages', 'dashboard', 'take_snapshots', 'earn_coins', 'share_with_freinds'].include?(controller_name) && !action_name == 'buyerDashboard'
    return permission_exists?('all_orders', controller_name) if controller_name == "orders" && action_name == 'index'
    return permission_exists?('scrap_blogs', controller_name) if controller_name == "scrap_blogs"
    true
  end

  def permission_exists?(action, controller)
    current_user.permissions.where(action_name: action, controller_name: controller).present?
  end
end
