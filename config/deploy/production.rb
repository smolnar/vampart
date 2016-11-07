set :stage, :production
set :branch, 'master'
set :app_path, "#{fetch(:application)}-#{fetch(:stage)}"
set :rails_env, :production
set :deploy_to, "/home/smolnar/projects/#{fetch(:app_path)}"

server '37.9.170.240', user: 'smolnar', roles: %w{app db web}
