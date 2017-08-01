lock '3.6.1'

set :application, 'foodcourt'
set :repo_url, 'git@bitbucket.org:achmad_rifaldi/foodcourt.git'
set :branch, 'master'

set :deploy_to, '/home/deploy/foodcourt'

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :bundle_binstubs, -> { shared_path.join('bin') }

set :passenger_restart_with_touch, true

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

