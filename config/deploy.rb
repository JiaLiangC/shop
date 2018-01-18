# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "p_shop"
set :repo_url, "ssh://git@43.254.55.136:10022/home/git/repositories/p_shop.git"

set :linked_files, %w{config/database.yml config/secrets.yml config/application.yml}

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/system public/uploads public/assets public/original}

set :keep_releases, 3

set :rbenv_type, :user
set :rbenv_ruby, '2.5.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl puma pumactl}
set :rbenv_roles, :all

namespace :sidekiq do
	task :start do
		on roles(:web) do
			with({:rails_env => fetch(:rails_env)}) do
				within release_path do
					# execute :sidekiq, 'db:create'
					execute "sidekiq -d"
				end
			end
		end
	end
end
