class Permission < ApplicationRecord
  belongs_to :user

  CONTROLLER_NAMES = { 'approve_sales': 'referral_sales', 'manage_rewards': 'point_types', 'configurations': 'settings', 'ban': 'users', 'deduct_points': 'users', 'brand_ambassadors': 'users',
                      'ambassadors': 'users', 'index': 'payments', 'categories': 'categories',  'page_desgin': 'dashboard'
                    }
end
