#!/usr/bin/env puma

directory '/home/deploy/affiliate-staging/current'
rackup "/home/deploy/affiliate-staging/current/config.ru"
environment 'staging'

tag ''

pidfile "/home/deploy/affiliate-staging/shared/tmp/pids/puma.pid"
state_path "/home/deploy/affiliate-staging/shared/tmp/pids/puma.state"
stdout_redirect '/home/deploy/affiliate-staging/current/log/puma.error.log', '/home/deploy/affiliate-staging/current/log/puma.access.log', true

threads 4,16

bind 'unix:///home/deploy/affiliate-staging/shared/tmp/sockets/affiliate-staging-puma.sock'

workers 2

preload_app!

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end
