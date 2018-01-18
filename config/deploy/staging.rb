set :deploy_to, "/var/www/p_shop/production"

set :stage, :production
set :rails_env, 'production'
set :branch, 'master'

set :puma_threads, [4, 16]
set :puma_workers, 0

set :puma_bind, "tcp://0.0.0.0:9292"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"

server 'hongbu.info', user: 'xuadmin', roles: %w{web app db}, port: 10022
