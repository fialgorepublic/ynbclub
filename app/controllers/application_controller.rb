class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_action :block_banned_users
  before_action :check_request_type
  before_action :set_locale
  before_action :allow_iframe_requests
  before_action :allow_user_request
  before_action :blog_not_found
  before_action :check_role
  before_action :redirect_to_blogs, if: :shopify_redirected?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_role
    return if current_user.blank?
    return if controller_name == 'dashboard'

    redirect_to dashboard_path if current_user.role.blank? || current_user.is_ambassador? && current_user.incomplete_profile?
  end

  def after_sign_up_path(resource)
    dashboard_path # after sign_up redirect to dashboard path
  end

  def after_sign_in_path_for(resource)
    dashboard_path # normal app users go to dashboard path
  end

  def initiate_shopify_session
    shopify_session = ShopifyAPI::Session.new(domain: "saintlbeau.myshopify.com", token: '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', api_version: '2019-04')
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

  def check_route
    redirect_to root_path, alert: 'The page you are trying to access does not exist.'
  end

  private

  def block_banned_users
    return if current_user.blank?
    return unless current_user.banned

    request.format = :html
    sign_out
    redirect_to root_path, alert: I18n.t(:banned_message)
  end

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

    redirect_to dashboard_path(blog_not_found: true) if controller_name == "home"
  end

  def set_earn_coin
    @earn_coin ||=
      EarnCoin.first
      begin
        if I18n.locale == :en
          unless @earn_coin.main_text == "<p> Get Saint money and redeem coupons </p>"
            translate_to_main_text = GoogleTranslateService.new(@earn_coin.main_text, @earn_coin.how_spend_text, @earn_coin.how_earn_text, @earn_coin.earn_way )
            translated_text = translate_to_main_text.translate.translate @earn_coin.main_text, @earn_coin.how_spend_text, @earn_coin.how_earn_text, @earn_coin.earn_way, to: "en"
            @earn_coin.update(main_text: translated_text.first.text, how_spend_text: translated_text.second.text, how_earn_text: translated_text.third.text, earn_way: translated_text.fourth.text )
          end
        else
          unless @earn_coin.main_text == "<p> Nhận tiền Saint và đổi phiếu giảm giá </p>"
            translate_to_main_text = GoogleTranslateService.new(@earn_coin.main_text, @earn_coin.how_spend_text, @earn_coin.how_earn_text, @earn_coin.earn_way)
            translated_text = translate_to_main_text.translate.translate @earn_coin.main_text, @earn_coin.how_spend_text, @earn_coin.how_earn_text, @earn_coin.earn_way , to: "vi"
            @earn_coin.update(main_text: translated_text.first.text, how_spend_text: translated_text.second.text, how_earn_text: translated_text.third.text, earn_way: translated_text.fourth.text )
          end
        end
      rescue
      end
    @earn_coin.point_types
  end

  def set_page
    @page ||= (Page.first || Page.create(heading: "Who are we?", sub_heading: ""))
  end

  def set_snapshot
    @snapshot ||= (Snapshot.first || Snapshot.create(step1_text: "Make selfie photo or video with product bought on your mobile", step2_text: "Upload to facebook , twitter or intstagram and copy link to your post, Don't forget to add a hashtag #saintlbeau",
                                      step3_text: "Insert copied link to the special field on the web site", step4_text: "Confirm and receive 20 coins!"))
  end

  def shopify_redirected?
    params[:shopify_blog_redirected].present?
  end

  def redirect_to_blogs
    redirect_to blogs_path if user_signed_in?
  end

  def get_share_with_friend
    @share_with_friends ||= (ShareWithFriend.first || create_new)
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
    return true  if current_user.present? && current_user.is_admin? #for admin user
    return false if controller_name == "permissions"
    return false if controller_name == "shared_urls"
    return true  if dashboard_default_option?(action_name)
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
    return permission_exists?('page_design', 'dashboard') if ['pages', 'dashboard', 'take_snapshots', 'earn_coins', 'share_with_freinds'].include?(controller_name)
    return permission_exists?('all_orders', controller_name) if controller_name == "orders" && action_name == 'index'
    return permission_exists?('scrap_blogs', controller_name) if controller_name == "scrap_blogs"
    #This is temporary permissions managment for group, need to be fixed and make it work as other permissions.
    return false if controller_name == 'groups' && ['new', 'create', 'edit', 'destroy', 'update'].include?(action_name)
    true
  end

  def permission_exists?(action, controller)
    current_user.permissions.where(action_name: action, controller_name: controller).present?
  end

  def dashboard_default_option?(action_name)
    ['dashboard', 'change_profile_picture', 'take_snapshot', 'get_user_object', 'step_one', 'step_two', 'step_three', 'share_with_friends', 'acc_settings', 'cities'].include?(action_name)
  end

  def check_request_type
    unless request.xhr?
      set_snapshot
      get_share_with_friend
      set_page
      set_earn_coin
    end
  end
end
