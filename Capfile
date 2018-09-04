root = File.join(File.dirname(__FILE__), '..')
set :application, "vivo_mapper"
set :repository, "ssh://#{ENV['USER']}@siss-webapp-test-01.oit.duke.edu//srv/git/#{application}"
set :deploy_to, "/srv/web/apps/vivo_mapper"
set :scm, "git"
set :scm_prefer_prompt, true
set :user, "tibbs001"
set :use_sudo, false
#ssh_options[:keys] = ["/opt/tibbs001/.ssh/id_dsa_community","#{ENV['HOME']}/.ssh/id_dsa"]

# fix for cap 2.1 or higher (see http://weblog.jamisbuck.org/2007/10/14/capistrano-2-1)
default_run_options[:pty] = true if respond_to? :default_run_options

# ---------------------------------------------------------
# Environment Setup Tasks
# ---------------------------------------------------------

desc "Set development environment"
task :development do
  set :branch, 'development'
  set :target_server, 'scholars-web-test-03.oit.duke.local'
  set :fdr_home, "/srv/web/facultydata-dev.oit.duke.edu/rails/apt/current"
  role :app, "scholars-web-test-03.oit.duke.local"
end

desc "Set test environment"
task :acceptance do
  set :branch, 'development'
  set :target_server, 'facultydata-web-dev-02.oit.duke.edu'
  set :fdr_home, "/srv/web/facultydata-dev.oit.duke.edu/rails/apt/current"
  role :app, "facultydata-web-dev-02.oit.duke.edu"
end

desc "Set pilot environment"
task :pilot do
  set :branch, 'development'
  set :target_server, 'facultydata-web-02.oit.duke.edu'
  set :fdr_home, '/srv/web/webservices.faculty.duke.edu/rails/apt/current'
  role :app, "facultydata-web-02.oit.duke.edu"
end

desc "Set production environment"
task :production do
  set :branch, 'master'
  set :target_server, 'facultydata-web-01.oit.duke.edu'
  set :fdr_home, '/srv/web/webservices.faculty.duke.edu/rails/apt/current'
  role :app, "facultydata-web-01.oit.duke.edu"
end

def display_run_local(cmd)
   puts " >> #{cmd}"
  `#{cmd}`
end

desc "tasks required before deployment"
task :deploy do
   display_run_local("git checkout #{branch}; git fetch; git pull")
   display_run_local("rm vivo_mapper.jar")
   display_run_local("cp ~/.rails/vivo_mapper/sdb_server.yml  ./config/sdb.yml")
   display_run_local("cp ~/.rails/vivo_mapper/databases/*.yml ./config/databases/")
   run "rm -rf /tmp/save_db; mkdir /tmp/save_db; mv #{deploy_to}/*.db /tmp/save_db; rm -rf #{deploy_to}/*; mv /tmp/save_db/* #{deploy_to}; rm -rf /tmp/save_db"
   display_run_local("warble executable jar --trace")
   display_run_local("scp vivo_mapper.jar #{user}@#{target_server}:#{deploy_to}")
   run "chmod a+x #{deploy_to}/vivo_mapper.jar"
   run "cd #{deploy_to}; unzip vivo_mapper.jar"
   run "rm -rf #{deploy_to}/vivo_mapper/incoming_files"
   run "ln -s #{fdr_home}/csv_files #{deploy_to}/vivo_mapper/incoming_files"
   run "cp ~/.vivo_mapper/sdb.yml #{deploy_to}/vivo_mapper/config/sdb.yml"
   run "cp ~/.vivo_mapper/fdr.yml #{deploy_to}/vivo_mapper/config/databases/fdr.yml"
   run "cp ~/.vivo_mapper/ps.yml #{deploy_to}/vivo_mapper/config/databases/ps.yml"
   display_run_local("cp ~/.rails/vivo_mapper/sdb_local.yml ./config/sdb.yml")
end

