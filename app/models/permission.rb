class Permission < ApplicationRecord
  belongs_to :user

  CONTROLLER_NAMES = ['referral_sales', 'blogs', 'point_types', 'settings', 'users', 'categories', 'orders', 'dashboard', 'permissions']
end
