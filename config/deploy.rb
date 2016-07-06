require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv' # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

ENV['to'] ||= "staging"
ENV['to'] = "staging" unless ["staging", "production"].include?(ENV['to'])

raise "missing domain, run with 'rake deploy domain=37.187.154.237'" if ENV['domain'].nil?

print "Deploy to #{ENV['to']} environment branch #{branch}\n"

# set :domain, '5.135.190.60'
set :domain, ENV['domain']
set :repository, 'https://github.com/sgmap/dashboard_apientreprise.git'
set :port, 2200

set :deploy_to, '/var/www/dashboard'


if ENV["to"] == "staging"
  if ENV['branch'].nil?
    set :branch, 'staging'
  else
    set :branch, ENV['branch']
  end
  set :deploy_to, '/var/www/dashboard'
  set :user, 'dashboard' # Username in the server to SSH to.
  appname = 'dashboard'
elsif ENV["to"] == "production"
  if ENV['branch'].nil?
    set :branch, 'master'
  else
    set :branch, ENV['branch']
  end
  set :deploy_to, '/var/www/dashboard'
  set :user, 'dashboard' # Username in the server to SSH to.
  appname = 'dashboard'
end


set :rails_env, ENV["to"]
# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, [
                     'log',
                     'bin',
                     'uploads',
                     'tmp/pids',
                     'tmp/cache',
                     'tmp/sockets',
                     'public/system',
                     'public/uploads',
                     'config/initializers/secret_token.rb',
                     "config/initializers/uptime_robot.rb",
                     "config/initializers/kibana.rb",
                     "config/unicorn.rb",
                     'config/initializers/mailjet.rb',
                     "config/initializers/raven.rb"
                 ]

set :rbenv_path, "/usr/local/rbenv/bin/rbenv"

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
set :forward_agent, true # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/bin"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/bin"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/cache"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/cache"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  queue 'export PATH=$PATH:/usr/local/rbenv/bin:/usr/local/rbenv/shims'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'

    to :launch do
      queue "/etc/init.d/#{user} upgrade "
    end
  end
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
