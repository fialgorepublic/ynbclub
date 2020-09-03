class Permission < ApplicationRecord
  belongs_to :user

  CONTROLLER_NAMES = { 'approve_sales': 'referral_sales', 'manage_rewards': 'point_types', 'configurations': 'settings', 'ban': 'users', 'deduct_points': 'users', 'brand_ambassadors': 'users',
                      'ambassadors': 'users', 'index': 'payments', 'categories': 'categories',  'page_design': 'dashboard', 'orders': 'all_orders',
                      'scrap_blogs': 'scrap_blogs', "share_blog": "blogs", "list": "blogs", "take_snapshot": "dashboard", "exchange_coins": "users", "index": "blogs", "videos": "dashboard", "index": "warranties"
                    }
end
