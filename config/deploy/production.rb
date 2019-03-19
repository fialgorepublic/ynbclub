set :stage,        :production
set :rails_env,    :production
set :application, 'saint-l-beau'
set :deploy_to,   "/var/www/production-#{fetch(:application)}"
set :branch,      :master
