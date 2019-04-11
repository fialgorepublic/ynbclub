# == Route Map
#
#                           Prefix Verb   URI Pattern                                 Controller#Action
#            clear_search_payments GET    /payments/clear_search(.:format)            payments#clear_search
#                         payments GET    /payments(.:format)                         payments#index
#                                  POST   /payments(.:format)                         payments#create
#                      new_payment GET    /payments/new(.:format)                     payments#new
#                     edit_payment GET    /payments/:id/edit(.:format)                payments#edit
#                          payment GET    /payments/:id(.:format)                     payments#show
#                                  PATCH  /payments/:id(.:format)                     payments#update
#                                  PUT    /payments/:id(.:format)                     payments#update
#                                  DELETE /payments/:id(.:format)                     payments#destroy
#                         settings GET    /settings(.:format)                         settings#index
#                                  POST   /settings(.:format)                         settings#create
#                      new_setting GET    /settings/new(.:format)                     settings#new
#                     edit_setting GET    /settings/:id/edit(.:format)                settings#edit
#                          setting GET    /settings/:id(.:format)                     settings#show
#                                  PATCH  /settings/:id(.:format)                     settings#update
#                                  PUT    /settings/:id(.:format)                     settings#update
#                                  DELETE /settings/:id(.:format)                     settings#destroy
#                         products GET    /products(.:format)                         products#index
#                                  POST   /products(.:format)                         products#create
#                      new_product GET    /products/new(.:format)                     products#new
#                     edit_product GET    /products/:id/edit(.:format)                products#edit
#                          product GET    /products/:id(.:format)                     products#show
#                                  PATCH  /products/:id(.:format)                     products#update
#                                  PUT    /products/:id(.:format)                     products#update
#                                  DELETE /products/:id(.:format)                     products#destroy
#                      point_types GET    /point_types(.:format)                      point_types#index
#                                  POST   /point_types(.:format)                      point_types#create
#                   new_point_type GET    /point_types/new(.:format)                  point_types#new
#                  edit_point_type GET    /point_types/:id/edit(.:format)             point_types#edit
#                       point_type GET    /point_types/:id(.:format)                  point_types#show
#                                  PATCH  /point_types/:id(.:format)                  point_types#update
#                                  PUT    /point_types/:id(.:format)                  point_types#update
#                                  DELETE /point_types/:id(.:format)                  point_types#destroy
#                         ckeditor        /ckeditor                                   Ckeditor::Engine
#                       categories GET    /categories(.:format)                       categories#index
#                                  POST   /categories(.:format)                       categories#create
#                     new_category GET    /categories/new(.:format)                   categories#new
#                    edit_category GET    /categories/:id/edit(.:format)              categories#edit
#                         category GET    /categories/:id(.:format)                   categories#show
#                                  PATCH  /categories/:id(.:format)                   categories#update
#                                  PUT    /categories/:id(.:format)                   categories#update
#                                  DELETE /categories/:id(.:format)                   categories#destroy
#                             home GET    /home(.:format)                             home#index
# upate_ghtk_status_referral_sales POST   /referral_sales/upate_ghtk_status(.:format) referral_sales#upate_ghtk_status
#                   referral_sales GET    /referral_sales(.:format)                   referral_sales#index
#                                  POST   /referral_sales(.:format)                   referral_sales#create
#                new_referral_sale GET    /referral_sales/new(.:format)               referral_sales#new
#               edit_referral_sale GET    /referral_sales/:id/edit(.:format)          referral_sales#edit
#                    referral_sale GET    /referral_sales/:id(.:format)               referral_sales#show
#                                  PATCH  /referral_sales/:id(.:format)               referral_sales#update
#                                  PUT    /referral_sales/:id(.:format)               referral_sales#update
#                                  DELETE /referral_sales/:id(.:format)               referral_sales#destroy
#                            blogs GET    /blogs(.:format)                            blogs#index
#                                  POST   /blogs(.:format)                            blogs#create
#                         new_blog GET    /blogs/new(.:format)                        blogs#new
#                        edit_blog GET    /blogs/:id/edit(.:format)                   blogs#edit
#                             blog GET    /blogs/:id(.:format)                        blogs#show
#                                  PATCH  /blogs/:id(.:format)                        blogs#update
#                                  PUT    /blogs/:id(.:format)                        blogs#update
#                                  DELETE /blogs/:id(.:format)                        blogs#destroy
#                    approve_sales GET    /approve_sales(.:format)                    referral_sales#approve_sales
#     changed_sale_approved_status GET    /changed_sale_approved_status(.:format)     referral_sales#changed_sale_approved_status
#                             root GET    /                                           home#index
#                        dashboard GET    /dashboard(.:format)                        dashboard#index
#                   buyerDashboard GET    /buyerDashboard(.:format)                   dashboard#buyerDashboard
#                   dashboard_main GET    /dashboard_main(.:format)                   dashboard#dashboard_main
#                 update_user_role GET    /update_user_role(.:format)                 dashboard#update_user_role
#                                  GET    /auth/:provider/callback(.:format)          sessions#create
#          add_partner_information POST   /add_partner_information(.:format)          partner_informations#add_partner_information
#                    add_user_info POST   /add_user_info(.:format)                    users#add_user_info
#                     get_referral GET    /get_referral(.:format)                     home#get_referral
#           change_profile_picture POST   /change_profile_picture(.:format)           dashboard#change_profile_picture
#                  get_user_object GET    /get_user_object(.:format)                  dashboard#get_user_object
#               share_with_friends GET    /share_with_friends(.:format)               dashboard#share_with_friends
#                      page_design GET    /page_design(.:format)                      dashboard#page_design
#                    take_snapshot GET    /take_snapshot(.:format)                    dashboard#take_snapshot
#                         step_one GET    /step_one(.:format)                         dashboard#step_one
#                         step_two GET    /step_two(.:format)                         dashboard#step_two
#                       step_three GET    /step_three(.:format)                       dashboard#step_three
#                      create_blog GET    /create_blog(.:format)                      blogs#create_blog
#                     acc_settings GET    /acc_settings(.:format)                     dashboard#acc_settings
#                     notification GET    /notification(.:format)                     dashboard#notification
#               take_snapshot_step GET    /take_snapshot_step(.:format)               dashboard#take_snapshot_step
#                     buyer_orders GET    /buyer_orders(.:format)                     buyers#buyer_orders
#                        user_show GET    /user_show(.:format)                        users#user_show
#                      add_comment GET    /add_comment(.:format)                      comments#add_comment
#                 blog_like_unlike GET    /blog_like_unlike(.:format)                 blogs#blog_like_unlike
#              comment_like_unlike GET    /comment_like_unlike(.:format)              comments#comment_like_unlike
#            change_featured_state GET    /change_featured_state(.:format)            blogs#change_featured_state
#                      add_payment GET    /add_payment(.:format)                      payments#add_payment
#                   update_profile POST   /update_profile(.:format)                   users#update_profile
#                   import_partner GET    /import_partner(.:format)                   users#import_partner
#                import_ambassador POST   /import_ambassador(.:format)                users#import_ambassador
#                     sign_in_user POST   /sign_in_user(.:format)                     home#sign_in_user
#                        my_orders GET    /my_orders(.:format)                        orders#my_orders
#                        home_page GET    /home_page(.:format)                        dashboard#home_page
#                 new_user_session GET    /d/users/sign_in(.:format)                  users/sessions#new
#                     user_session POST   /d/users/sign_in(.:format)                  users/sessions#create
#             destroy_user_session DELETE /d/users/sign_out(.:format)                 users/sessions#destroy
#                new_user_password GET    /d/users/password/new(.:format)             users/passwords#new
#               edit_user_password GET    /d/users/password/edit(.:format)            users/passwords#edit
#                    user_password PATCH  /d/users/password(.:format)                 users/passwords#update
#                                  PUT    /d/users/password(.:format)                 users/passwords#update
#                                  POST   /d/users/password(.:format)                 users/passwords#create
#         cancel_user_registration GET    /d/users/cancel(.:format)                   users/registrations#cancel
#            new_user_registration GET    /d/users/sign_up(.:format)                  users/registrations#new
#           edit_user_registration GET    /d/users/edit(.:format)                     users/registrations#edit
#                user_registration PATCH  /d/users(.:format)                          users/registrations#update
#                                  PUT    /d/users(.:format)                          users/registrations#update
#                                  DELETE /d/users(.:format)                          users/registrations#destroy
#                                  POST   /d/users(.:format)                          users/registrations#create
#                          sign_in GET    /sign_in(.:format)                          users/sessions#new
#                          sign_up GET    /sign_up(.:format)                          users/registrations#new
#                         sign_out GET    /sign_out(.:format)                         users/sessions#destroy
#              change_activeStatus GET    /change_activeStatus(.:format)              users#change_activeStatus
#               update_email_users POST   /users/update_email(.:format)               users#update_email
#            update_password_users POST   /users/update_password(.:format)            users#update_password
#          brand_ambassadors_users GET    /users/brand_ambassadors(.:format)          users#brand_ambassadors
#               clear_search_users GET    /users/clear_search(.:format)               users#clear_search
#                     points_users GET    /users/points(.:format)                     users#points
#         find_user_by_email_users GET    /users/find_user_by_email(.:format)         users#find_user_by_email
#                  users_ban_users GET    /users/users/ban(.:format)                  users#all_users
#          change_ban_status_users GET    /users/change_ban_status(.:format)          users#ban
#              deduct_points_users GET    /users/deduct_points(.:format)              users#deduct_points
#                            users GET    /users(.:format)                            users#index
#                                  POST   /users(.:format)                            users#create
#                         new_user GET    /users/new(.:format)                        users#new
#                        edit_user GET    /users/:id/edit(.:format)                   users#edit
#                             user GET    /users/:id(.:format)                        users#show
#                                  PATCH  /users/:id(.:format)                        users#update
#                                  PUT    /users/:id(.:format)                        users#update
#                                  DELETE /users/:id(.:format)                        users#destroy
#                   set_commission PUT    /set_commission(.:format)                   settings#set_commission
#  changed_account_approved_status GET    /changed_account_approved_status(.:format)  settings#changed_account_approved_status
#        get_products_from_shopify GET    /get_products_from_shopify(.:format)        products#get_products_from_shopify
#            get_selected_products GET    /get_selected_products(.:format)            products#get_selected_products
#            change_publish_status GET    /change_publish_status(.:format)            blogs#change_publish_status
#         change_buyer_show_status GET    /change_buyer_show_status(.:format)         blogs#change_buyer_show_status
#                       buyer_show GET    /buyer_show(.:format)                       blogs#buyer_show
#                      blog_detail GET    /blog_detail(.:format)                      blogs#blog_detail
#                       share_blog GET    /share_blog(.:format)                       blogs#share_blog
#                         profiles GET    /profiles(.:format)                         profiles#index
#                                  POST   /profiles(.:format)                         profiles#create
#                      new_profile GET    /profiles/new(.:format)                     profiles#new
#                     edit_profile GET    /profiles/:id/edit(.:format)                profiles#edit
#                          profile GET    /profiles/:id(.:format)                     profiles#show
#                                  PATCH  /profiles/:id(.:format)                     profiles#update
#                                  PUT    /profiles/:id(.:format)                     profiles#update
#                                  DELETE /profiles/:id(.:format)                     profiles#destroy
#                      api_cookies GET    /api/cookies(.:format)                      api/cookies#index
#                                  POST   /api/cookies(.:format)                      api/cookies#create
#                    new_api_cooky GET    /api/cookies/new(.:format)                  api/cookies#new
#                   edit_api_cooky GET    /api/cookies/:id/edit(.:format)             api/cookies#edit
#                        api_cooky GET    /api/cookies/:id(.:format)                  api/cookies#show
#                                  PATCH  /api/cookies/:id(.:format)                  api/cookies#update
#                                  PUT    /api/cookies/:id(.:format)                  api/cookies#update
#                                  DELETE /api/cookies/:id(.:format)                  api/cookies#destroy
#          edit_share_with_friends GET    /share_with_friends/edit(.:format)          share_with_friends#edit
#                                  PATCH  /share_with_friends(.:format)               share_with_friends#update
#                                  PUT    /share_with_friends(.:format)               share_with_friends#update
#                   edit_earn_coin GET    /earn_coins/:id/edit(.:format)              earn_coins#edit
#                        earn_coin PATCH  /earn_coins/:id(.:format)                   earn_coins#update
#                                  PUT    /earn_coins/:id(.:format)                   earn_coins#update
#                        edit_page GET    /page/edit(.:format)                        pages#edit
#                             page GET    /page(.:format)                             pages#show
#                                  PATCH  /page(.:format)                             pages#update
#                                  PUT    /page(.:format)                             pages#update
#              edit_take_snapshots GET    /take_snapshots/edit(.:format)              take_snapshots#edit
#                   take_snapshots PATCH  /take_snapshots(.:format)                   take_snapshots#update
#                                  PUT    /take_snapshots(.:format)                   take_snapshots#update
#                                  DELETE /take_snapshots(.:format)                   take_snapshots#destroy
# 
# Routes for Ckeditor::Engine:
#         pictures GET    /pictures(.:format)             ckeditor/pictures#index
#                  POST   /pictures(.:format)             ckeditor/pictures#create
#          picture DELETE /pictures/:id(.:format)         ckeditor/pictures#destroy
# attachment_files GET    /attachment_files(.:format)     ckeditor/attachment_files#index
#                  POST   /attachment_files(.:format)     ckeditor/attachment_files#create
#  attachment_file DELETE /attachment_files/:id(.:format) ckeditor/attachment_files#destroy

Rails.application.routes.draw do
  resources :payments do
    collection do
      get :clear_search
    end
  end
  resources :settings
  resources :point_types
  mount Ckeditor::Engine => '/ckeditor'
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

  resources :blogs
  get 'approve_sales', to: 'referral_sales#approve_sales'
  get 'changed_sale_approved_status', to: 'referral_sales#changed_sale_approved_status'
  root :to => 'home#index'
  get 'dashboard', to: 'dashboard#index'
  get 'cities', to: 'dashboard#cities'
  get 'buyerDashboard', to: 'dashboard#buyerDashboard'
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

  resources :orders, only: [:index, :create, :update] do
    get :send_to_ghtk
    get :edit_address
    get :update_phone_status
    collection do
      get :district_cities
      get :wards
      get :my
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
    end
  end

  put 'set_commission', to: 'settings#set_commission'
  get 'changed_account_approved_status', to: 'settings#changed_account_approved_status'
  get 'get_products_from_shopify', to: 'products#get_products_from_shopify'
  get 'get_selected_products', to: 'products#get_selected_products'
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
  resource  :take_snapshots, only: [:edit, :update, :destroy]
  resources :permissions, only: [:index, :show, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
