module PermissionsHelper
  def show_dashboard_related_name(controller, action)
    action = action.to_s
    case controller
    when 'referral_sales'
      I18n.t('sidebar.approve_sales_label') if action == 'approve_sales'
    when 'point_types'
      I18n.t('sidebar.manage_rewards_label')
    when 'settings'
      I18n.t('sidebar.configuration_label')
    when 'payments'
      I18n.t('sidebar.payment_histroy_label')
    when 'users'
      return I18n.t('sidebar.ban_users_label') if action == 'ban'
      return I18n.t('sidebar.deduct_points_label') if action == 'deduct_points'
      return I18n.t('sidebar.commission_label') if action == 'brand_ambassadors'
      return I18n.t('sidebar.exchange_coins_label') if action == 'exchange_coins'
      I18n.t('sidebar.ambassadors_label')
    when 'categories'
      I18n.t('sidebar.categories_label')
    when 'dashboard'
      return I18n.t('sidebar.pages_design_label') if action == 'page_design'
      return "Videos" if action == 'videos'
      I18n.t('sidebar.take_and_share_label')
    when 'all_orders'
      I18n.t('sidebar.all_orders_label')
    when 'scrap_blogs'
      I18n.t('blogs.index.blog_libray_label')
    when 'blogs'
      return I18n.t('blogs.index.share_blog_label') if action == 'share_blog'
      return I18n.t('sidebar.blogs_label') if action == 'index'
      I18n.t('blogs.index.list_blog_label')
    when 'warranties'
      I18n.t('sidebar.warranty_label')
    end
  end

  def already_permitted?(permissions, controller, action)
    permissions.find_by(controller_name: controller, action_name: action).present?
  end
end
