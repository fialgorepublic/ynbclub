set :application, 'affiliate-staging'
set :deploy_to,    "/home/deploy/#{fetch(:application)}"
set :stage,        :staging
set :rails_env,    :staging
set :branch,       :staging
