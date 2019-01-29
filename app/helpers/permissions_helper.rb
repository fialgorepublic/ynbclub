module PermissionsHelper
  def show_dashboard_related_name(controller, action)
    action = action.to_s
    case controller
    when 'referral_sales'
      'Approve Sales' if action == 'approve_sales'
    when 'point_types'
      'Manage Rewards'
    when 'settings'
      'Configuration'
    when 'payments'
      'Payments'
    when 'users'
      return 'Ban Users' if action == 'ban'
      return 'Deduct Points' if action == 'deduct_points'
      return 'Brand Ambassadors' if action == 'brand_ambassadors'
      'Ambassadors'
    when 'categories'
      'Categories'
    when 'dashboard'
      'Pages Design'
    end
  end

  def already_permitted?(permissions, controller, action)
    permissions.find_by(controller_name: controller, action_name: action).present?
  end
end
