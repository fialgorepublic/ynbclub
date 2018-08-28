Rails.application.routes.draw do
  get 'home', to: 'home#index'
  resources :referral_sales
  get 'approve_sales', to: 'referral_sales#approve_sales'
  root :to => 'home#index'
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard_main', to: 'dashboard#dashboard_main'
  get 'update_user_role', to: 'dashboard#update_user_role'
  get 'auth/:provider/callback', to: 'sessions#create'
  post "add_partner_information", to: 'partner_informations#add_partner_information'
  get "get_referral", to: 'home#get_referral'
  post "change_profile_picture", to: "dashboard#change_profile_picture"
  get "get_user_object", to: "dashboard#get_user_object"
  get 'share_with_friends', to: 'dashboard#share_with_friends'
  get 'take_snapshot', to: 'dashboard#take_snapshot'
  get 'step_one', to: 'dashboard#step_one'
  get 'step_two', to: 'dashboard#step_two'
  get 'step_three', to: 'dashboard#step_three'
  get 'create_blog', to: 'dashboard#create_blog'
  get 'acc_settings', to: 'dashboard#acc_settings'
  get 'notification', to: 'dashboard#notification'
  get 'take_snapshot_step', to: 'dashboard#take_snapshot_step'
  get 'buyer_orders', to: 'buyers#buyer_orders'
  get 'user_show', to: 'users#user_show'
  post 'update_profile', to: 'users#update_profile'
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
    end
  end

  put 'set_commission', to: 'settings#set_commission'
  get 'changed_account_approved_status', to: 'settings#changed_account_approved_status'

  resources :profiles

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
