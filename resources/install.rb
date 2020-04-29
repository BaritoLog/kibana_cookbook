resource_name :kibana_install

property :version, String, default: ''
property :base_dir, String, default: '/opt/kibana'
property :user, String, default: ''
property :group, String, default: ''

default_action :install

action :install do
  version = new_resource.version == '' ? node['kibana']['version'] : new_resource.version
  user = new_resource.user == '' ? node['kibana']['user'] : new_resource.user
  group = new_resource.group == '' ? node['kibana']['group'] : new_resource.group

  distrib_url = "#{node['kibana']['distribution_base_url']}/kibana-#{version}-linux-x86_64.tar.gz"
  distrib_checksum = node['kibana']['distrib_checksum']

  install_dir = ::File.join(new_resource.base_dir, version)

  group group

  user user do
    comment 'Kibana User'
    gid group
    home new_resource.base_dir
    shell '/bin/bash'
    system true
  end

  directory install_dir do
    mode '0755'
    owner user
    group group
    recursive true
  end

  ark 'kibana' do
    url distrib_url
    version version
    path install_dir
    home_dir ::File.join(install_dir, 'current')
    owner user
  end

  node.default['kibana']['config_file'] = ::File.join(install_dir, 'current/config/kibana.yml')
  node.default['kibana']['exec_file'] = ::File.join(install_dir, 'current/bin/kibana')
end