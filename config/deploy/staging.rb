set :application, 'affiliate-staging'
set :deploy_to,    "/home/deploy/#{fetch(:application)}"
set :stage,        :staging
set :rails_env,    :staging
set :branch,       :staging

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
