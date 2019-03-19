set :stage,        :staging
set :application, 'saintlbeau'
set :deploy_to,    "/var/www/staging-#{fetch(:application)}"
set :rails_env,    :staging
set :branch,       :staging
