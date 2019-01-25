module PermissionsHelper
  def show_dashboard_related_name(name)
    case name
    when 'referral_sales'
      [true, 'Approve Sales, My Sales']
    when 'blogs'
      [true, 'Blogs']
    when 'point_types'
      [true, 'Manage Rewards']
    when 'settings'
      [true, 'Configuration']
    when 'payments'
      [true, 'Payments']
    when 'users'
      [true, 'Ban Users, Ambassadors, Deduct Points']
    when 'categories'
      [true, 'Categories']
    when 'orders'
      [true, 'All Orders, My orders']
    when 'dashboard'
      [true, 'Acc Settings, Pages Design']
    when 'permissions'
      [true, 'Permissions']
    else
      [false, '']
    end
  end

  def already_permitted?(permissions, controller)
    permissions.pluck(:controller_name).include?(controller)
  end
end
