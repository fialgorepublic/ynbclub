Rails.application.routes.draw do
  get 'home', to: 'home#index'
  root :to => 'home#index'
  get 'dashboard', to: 'dashboard#index'
  get 'update_user_role', to: 'dashboard#update_user_role'
  get 'auth/:provider/callback', to: 'sessions#create'
  post "add_partner_information", to: 'partner_informations#add_partner_information'
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
