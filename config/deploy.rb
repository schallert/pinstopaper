require "bundler/capistrano"

server("YOUR_SERVER_IP", :app, :web, :db, { :primary => true })

set(:application, "pinstopaper")
set(:user, "matt")
set(:deploy_to, "/opt/#{application}")
set(:deploy_via, :remote_cache)
set(:use_sudo, false)

set(:scm, "git")
set(:repository, "git@github.com:schallert/#{application}.git")
set(:branch, "master")

# Make rbenv work
set(:default_environment, { 'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" })

# Don't try to do weird rails asset shit
# set(:normalize_asset_timestamps, false)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

before("deploy", "deploy:check_revision")

after("deploy", "deploy:cleanup") # keep only the last 5 releases
after("deploy", "deploy:reload_nginx")
after("deploy:setup", "deploy:setup_config")

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      run "sudo service unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    run "sudo ln -nfs #{current_path}/config/nginx_pinstopaper.conf /etc/nginx/sites-enabled/#{application}"
    run "sudo ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"

    run "mkdir -p #{shared_path}/log"
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  desc "Reload nginx config files"
  task :reload_nginx do
    # Reload configs, don't need to restart the server
    run "sudo service nginx reload"
  end
end
