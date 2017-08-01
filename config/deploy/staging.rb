set :stage, :production

server '104.196.130.64', user: 'deploy', roles: %w{web app db}
