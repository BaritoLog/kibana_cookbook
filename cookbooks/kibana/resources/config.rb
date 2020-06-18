resource_name :kibana_config

property :svc_name, String, name_property: true
property :user, String, default: ''
property :group, String, default: ''
property :configuration, Hash, required: true
property :template_cookbook, String, default: 'kibana'

default_action :config

action :config do
  user = new_resource.user == '' ? node['kibana']['user'] : new_resource.user
  group = new_resource.group == '' ? node['kibana']['group'] : new_resource.group

  systemd_service new_resource.svc_name do
    unit do
      description 'Kibana'
    end
    service do
      type 'simple'
      user user
      environment 'NODE_ENV=production'
      exec_start node['kibana']['exec_file']
    end
    install do
      wanted_by 'multi-user.target'
    end
  end

  config = new_resource.configuration

  directory ::File.dirname(config['logging.dest']) do
    owner user
    group group
    mode '0755'
    recursive true
    action :create
    not_if { (config['logging.dest'] == 'stdout') || (config['logging.dest'] == '/var/log/kibana.log') }
  end

  file config['logging.dest'] do
    mode '0644'
    owner user
    group group
    not_if { config['logging.dest'] == 'stdout' }
  end

  puts "kibana_configg: #{node['kibana']['config_file']}"
  puts "template_cookbook: #{new_resource.template_cookbook}"
  puts "configgg: #{config}"
  template node['kibana']['config_file'] do
    cookbook new_resource.template_cookbook
    source '/default/kibana.yml.erb'
    owner user
    group group
    mode '0644'
    variables config: config
    notifies :restart, "service[#{new_resource.svc_name}]"
  end

  template '/etc/logrotate.d/kibana' do
    source 'logrotate/kibana.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables log_file: node['kibana']['config']['logging.dest']
  end

  service new_resource.svc_name do
    supports start: true, restart: true, stop: true, status: true
    action [:enable, :restart]
  end
end