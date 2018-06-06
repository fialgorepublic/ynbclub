Rails.application.routes.draw do
  get 'home', to: 'home#index'
  resources :referral_sales
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
  get 'take_snapshot_step', to: 'dashboard#take_snapshot_step'
  get 'buyer_orders', to: 'buyers#buyer_orders'
  # get 'auth/failure', to: redirect('/')
  devise_for :users, :controllers => {
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
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
