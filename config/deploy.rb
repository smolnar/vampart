# config valid only for current version of Capistrano
lock '3.6.1'

# Repository
set :application, 'vampart'
set :scm, :git
set :repo_url, 'git@github.com:smolnar/vampart.git'

# Rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Links
set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/downloads', 'vendor/bundle', 'storage', 'public/uploads')

set :keep_releases, 2
set :ssh_options, {
  forward_agent: true
}

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  after 'finishing', 'deploy:cleanup'
  after 'deploy:restart', 'openface:restart'

  desc 'Restart Unicorn'
  task :restart do
    invoke 'unicorn:stop'
    sleep 2
    invoke 'unicorn:start'
  end

  desc 'Deploy app for first time'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'deploy:database' # This replaces deploy:migrations
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Setup database'
  task :database do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:create'
          execute :rake, 'db:migrate'
          execute :rake, 'db:seed'
        end
      end
    end
  end
end

namespace :openface do
  desc 'Restart OpenFace Docker Image'
  task :restart do
    on roles(:app) do
      within release_path do
        execute 'docker stop vampart_openface_api || exit 0'
        execute 'docker rm vampart_openface_api || exit 0'
        execute :'docker-compose', 'up -d openface'
      end
    end
  end
end
