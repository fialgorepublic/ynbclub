set :application, 'affiliate-production'
set :deploy_to,   "/home/deploy/#{fetch(:application)}"
set :stage,        :production
set :rails_env,    :production
set :branch,      :master
