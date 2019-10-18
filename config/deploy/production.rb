set :application, 'affiliate-production'
set :deploy_to,   "/home/deploy/#{fetch(:application)}"
set :stage,        :production
set :rails_env,    :production
set :branch,      :master

set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind,       "unix:///home/deploy/#{fetch(:application)}/shared/tmp/sockets/affiliate.sock"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
