elast_ver = node['elastalert']['version']
elast_repo = node['elastalert']['repository']
elast_es_host = node['elastalert']['elasticsearch']['hostname']
elast_es_port = node['elastalert']['elasticsearch']['port']
elast_es_index = node['elastalert']['elasticsearch']['index']
elast_es_old_index = node['elastalert']['elasticsearch']['index_old']
elast_es_url_prefix = node['elastalert']['elasticsearch']['url_prefix']
elast_es_index_create_opts = node['elastalert']['elasticsearch']['create_index_opts']
elast_group = node['elastalert']['group']
elast_user = node['elastalert']['user']
elast_user_home = node['elastalert']['user_home']
elast_dir = node['elastalert']['directory']
elast_rules_dir = node['elastalert']['rules_directory']
elast_log_dir = node['elastalert']['log_dir']

elast_server_repo = node['elastalert_server']['repository']
elast_server_dir = node['elastalert_server']['directory']
rule_templates_dir = node['elastalert']['rule_templates_dir']

kibana_dir = node['kibana']['config']['base_dir']
kibana_ver = node['kibana']['version']
kibana_user = node['kibana']['user']
kibana_group = node['kibana']['group']
elastalert_plugin_ver = node['elastalert_plugin']['version']

elastalert_plugin_name = "elastalert-kibana-plugin-#{elastalert_plugin_ver}-#{kibana_ver}"

if Chef::VERSION.split('.')[0].to_i > 12
  apt_update
else
  apt_update 'apt update' do
    action :update
  end
end

%w(python3-pip python3-setuptools build-essential libssl-dev libffi-dev python3-dev).each do |package|
  apt_package package
end

group elast_group do
  system true
end

user elast_user do
  comment "#{elast_user} user"
  group elast_group
  home elast_user_home
  manage_home true
  system true
end

# remote_file "/tmp/#{elastalert_plugin_name}.zip" do
#   source "https://github.com/bitsensor/elastalert-kibana-plugin/releases/download/#{elastalert_plugin_ver}/elastalert-kibana-plugin-#{elastalert_plugin_ver}-#{kibana_ver}.zip"
#   owner kibana_user
#   group kibana_group
#   not_if { ::File.exist?("/tmp/#{elastalert_plugin_name}.zip") }
# end

directory elast_dir do
  owner elast_user
  group elast_group
  mode '0755'
  recursive true
end

git elast_repo do
  repository elast_repo
  revision elast_ver
  destination elast_dir
  user elast_user
  group elast_group
  action :checkout
end

execute 'pip_install' do
  command "pip3 install setuptools>=11.3"
end

execute 'python setup.py install' do
  command "python3 setup.py install"
  cwd elast_dir
end

execute 'pip_install requirement' do
  command "sed -i 's/jira>=1.0.10,<1.0.15/jira>=2.0.0/g' requirements.txt && pip3 install -r #{elast_dir}/requirements.txt"
  cwd elast_dir
end

directory elast_rules_dir do
  user elast_user
  group elast_group
  mode '0755'
  recursive true
end

directory elast_log_dir do
  user elast_user
  group elast_group
  mode '0755'
  recursive true
end

#setup elastalert server
directory elast_server_dir do
  owner elast_user
  group elast_group
  mode '0755'
  recursive true
end

git elast_server_repo do
  repository elast_server_repo
  destination elast_server_dir
  user elast_user
  group elast_group
  action :sync
end

# include_recipe "nodejs::npm"

# npm_package 'elastalert' do
#   path "#{elast_server_dir}" # The root path to your project, containing a package.json file
#   json true
#   user elast_user
#   options ['--production', '--quite'] # Only install dependencies. Skip devDependencies
# end

# curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
# sudo apt-get install -y nodejs

# mkdir -p /opt/elastalert/rules/ /opt/elastalert/server_data/tests/

execute 'download nodejs' do
  command "sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -"
end

apt_package "nodejs"

execute "npm install elastalert" do
  command "npm install --production --quiet"
  cwd elast_server_dir
end

# execute "Download elastalert plugin" do
#   command "wget -O /tmp/#{elastalert_plugin_name}.zip https://github.com/bitsensor/elastalert-kibana-plugin/releases/download/#{elastalert_plugin_ver}/elastalert-kibana-plugin-#{elastalert_plugin_ver}-#{kibana_ver}.zip"
#   user kibana_user
#   group kibana_group
#   not_if { ::File.exist?("/tmp/#{elastalert_plugin_name}.zip") }
# end

remote_file "/tmp/#{elastalert_plugin_name}.zip" do
  source "https://github.com/bitsensor/elastalert-kibana-plugin/releases/download/#{elastalert_plugin_ver}/elastalert-kibana-plugin-#{elastalert_plugin_ver}-#{kibana_ver}.zip"
  user kibana_user
  group kibana_group
  not_if { ::File.exist?("/tmp/#{elastalert_plugin_name}.zip") }
end

execute 'install elastalert plugin' do
  command "#{kibana_dir}/#{kibana_ver}/current/bin/kibana-plugin install file:///tmp/#{elastalert_plugin_name}.zip"
  user kibana_user
  group kibana_group
  not_if { ::File.exist?("#{kibana_dir}/elastalert_plugin_installed.txt") }
end

file "#{kibana_dir}/elastalert_plugin_installed.txt" do
  owner kibana_user
  group kibana_group
  not_if { ::File.exist?("#{kibana_dir}/elastalert_plugin_installed.txt") }
end

template "#{elast_dir}/config.yml" do
  source '/default/elastalert/config.yml.erb'
  owner elast_user
  group elast_group
  mode '0755'
end

template "#{elast_dir}/config-test.yaml" do
  source '/default/elastalert/config.yml.erb'
  owner elast_user
  group elast_group
  mode '0755'
end

execute "cp rule_templates to elastalert" do
  command "cp -rp #{elast_server_dir}/rule_templates #{elast_dir}/rule_templates"
  user elast_user
  group elast_group
  not_if { ::File.exist?("#{elast_dir}/rule_templates") }
end

execute "cp elastalert_modules to elastalert" do
  command "cp -rp #{elast_server_dir}/elastalert_modules #{elast_dir}/elastalert_modules"
  user elast_user
  group elast_group
  not_if { ::File.exist?("#{elast_dir}/elastalert_modules") }
end

execute "npm start" do
  command "npm start"
  user elast_user
  group elast_group
  cwd elast_server_dir
end

service 'kibana' do
  supports start: true, restart: true, stop: true, status: true
  action [:enable, :restart]
end