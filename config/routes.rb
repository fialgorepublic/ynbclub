Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  mount Ckeditor::Engine => '/ckeditor'

  resources :payments do
    collection do
      get :clear_search
    end
  end
  resources :settings
  resources :point_types
  resources :categories
  get 'home', to: 'home#index'
  resources :referral_sales do
    collection do
      post :upate_ghtk_status
      post :ghtk_status
    end
  end

  resources :scrap_blogs, path: :medium_blogs, only: [:index, :destroy] do
    get :translate_and_edit, on: :member
  end

  resources :blogs do
    collection do
      get :list
      get  :feed
      post :banner
      post :create_or_update_cateogry
      get  :new_wizard, as: 'wizard'
      get :exceed_limit
    end
    get :shared
  end
  get 'approve_sales', to: 'referral_sales#approve_sales'
  get 'changed_sale_approved_status', to: 'referral_sales#changed_sale_approved_status'
  root :to => 'home#index'
  get 'dashboard', to: 'dashboard#index'
  get 'cities', to: 'dashboard#cities'
  get 'dashboard_main', to: 'dashboard#dashboard_main'
  get 'update_user_role', to: 'dashboard#update_user_role'
  get 'auth/:provider/callback', to: 'sessions#create'
  post "add_partner_information", to: 'partner_informations#add_partner_information'
  post "add_user_info", to: 'users#add_user_info'
  get "get_referral", to: 'home#get_referral'
  post "change_profile_picture", to: "dashboard#change_profile_picture"
  get "get_user_object", to: "dashboard#get_user_object"
  get 'share_with_friends', to: 'dashboard#share_with_friends'
  # get 'earn_coin', to: 'dashboard#earn_coin'
  get 'page_design', to: 'dashboard#page_design'
  get 'take_snapshot', to: 'dashboard#take_snapshot'
  get 'step_one', to: 'dashboard#step_one'
  get 'step_two', to: 'dashboard#step_two'
  get 'step_three', to: 'dashboard#step_three'
  get 'create_blog', to: 'blogs#create_blog'
  get 'acc_settings', to: 'dashboard#acc_settings'
  get 'notification', to: 'dashboard#notification'
  get 'take_snapshot_step', to: 'dashboard#take_snapshot_step'
  get 'user_show', to: 'users#user_show'
  get 'add_comment', to: 'comments#add_comment'
  get 'blog_like_unlike', to: 'blogs#blog_like_unlike'
  get 'comment_like_unlike', to: 'comments#comment_like_unlike'
  get 'change_featured_state', to: 'blogs#change_featured_state'
  get 'add_payment', to: 'payments#add_payment'
  post 'update_profile', to: 'users#update_profile'
  get 'import_partner', to: 'users#import_partner'
  post 'import_ambassador', to: 'users#import_ambassador'
  post 'sign_in_user', to: 'home#sign_in_user'
  # get 'my_orders', to: 'orders#my_orders'
  get 'home_page', to: 'dashboard#home_page'
  get 'set_language', to: 'home#set_default_language'
  get 'videos', to: 'dashboard#videos'
  get 'profile_admin', to: 'dashboard#profile'

  resources :orders, only: [:index, :create, :update] do
    get :send_to_ghtk
    get :edit_address
    get :update_phone_status
    collection do
      get :district_cities
      get :wards
      get :my
      get :update_status
    end
  end
  resources :shared_urls,   only: [:index]
  resources :notifications, only: [:index]

  # get 'auth/failure', to: redirect('/')
  devise_for :users, :path_prefix => 'd', :controllers => {
      :sessions => "users/sessions",
      :confirmations => "users/confirmations",
      :passwords => "users/passwords",
      :registrations => "users/registrations",
      :unlocks => "users/unlocks",
  }
  devise_scope :user do
    # root :to => 'users/sessions#new'
    get "sign_in", to: "users/sessions#new"
    get "sign_up", to: "users/registrations#new"
    get "sign_out", to: "users/sessions#destroy"

  end
  get 'change_activeStatus', to: 'users#change_activeStatus'

  resources :users do
    collection do
      post :update_email
      post :update_password
      get :brand_ambassadors
      get :clear_search
      get :points
      get :find_user_by_email
      get :find_user
      get 'users/ban', to: 'users#all_users'
      get '/change_ban_status', to: 'users#ban'
      get :deduct_points
      get :exchange_coins
      post :generate_discount_code
      get :update_share_link_count
      get :share_link_count, path: '/invite_count'
      get :earnings
    end

    resources :groups, only: [:index], controller: 'users/groups' do
      member do
        get :join
        get :leave
      end
    end

    resources :blogs, only: [:index], controller: 'users/blogs'
  end

  put 'set_commission', to: 'settings#set_commission'
  get 'changed_account_approved_status', to: 'settings#changed_account_approved_status'
  get 'get_products_from_shopify', to: 'products#get_products_from_shopify'
  get 'get_selected_products', to: 'products#get_selected_products'
  get 'search_products', to: 'products#search_products'
  get 'change_publish_status', to: 'blogs#change_publish_status'
  get 'change_buyer_show_status', to: 'blogs#change_buyer_show_status'
  get 'buyer_show', to: 'blogs#buyer_show'
  get 'blog_detail', to: 'blogs#blog_detail'
  get 'share_blog', to: 'blogs#share_blog'

  resources :profiles
  namespace :api do
    resources :cookies
  end

  resource  :share_with_friends, only: [:edit, :update]
  resources :earn_coins, only: [:edit, :update]
  resource  :page, only: [:show, :edit, :update]
  resource  :take_snapshots, only: [:edit, :update, :destroy] do
    post :banner, on: :collection
  end
  resources :permissions, only: [:index, :show, :create]
  resources :groups do
    collection do
      post :banner
      get  :search
    end
    get :users, on: :member
    resources :conversations, only: [:index], module: 'groups'
  end
  resources :group_categories

  resources :conversations do
    collection do
      post :banner
      get  :search
      post :conversation_reply
    end
    member do
      get :reply
      get :replies
      get :like
      get :dislike
    end
  end

  resources :follows, only: [:index] do
    collection do
      get :follow
      get :unfollow
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
