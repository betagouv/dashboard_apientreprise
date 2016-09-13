# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

task :deploy do
  domains = %w(149.202.220.111 149.202.72.152 149.202.198.6)
  domains.each do |domain|
    sh "mina deploy domain=#{domain}"
  end
end

task :deploy_ha do
  domains = %w(149.202.72.152 149.202.198.6 149.202.220.111)
  domains.each do |domain|
    sh "mina deploy domain=#{domain}"
  end
end

task :deploy_test do
  domains = %w(test_sgmap)
  branch = 'master'
  domains.each do |domain|
    sh "mina deploy domain=#{domain} branch=#{branch}"
  end
end
