default['kibana']['url'] = nil
default['kibana']['checksum'] = nil

default['kibana']['version'] = '7.3.0'
default['kibana']['distrib_checksum'] = 'd9d28d620a70a126747ee004042f4e728aaff05d9efc954739d3c15209acd4093321871423f486b51842a8e7b24ae969081702928802088c0e8bca22959e37aa'
default['kibana']['distribution_base_url'] = 'https://artifacts.elastic.co/downloads/kibana'
default['kibana']['user'] = 'kibana'
default['kibana']['group'] = 'kibana'

override['kibana']['config']['base_dir'] = '/opt/kibana'
override['kibana']['config']['logging.dest'] = '/var/log/kibana.log'

default['kibana']['config']['server.basePath'] = '/test'
default['kibana']['config']['server.port'] = '5601'
default['kibana']['config']['server.host'] = 'localhost'
default['kibana']['config']['elasticsearch.url'] = 'http://elasticsearch.service.consul:9200'
default['kibana']['config']['elasticsearch.hosts'] = ["http://elasticsearch.service.consul:9200"]
default['kibana']['config']['elasticsearch.sniffInterval'] = false
default['kibana']['config']['elasticsearch.sniffOnStart'] = false
default['kibana']['config']['elasticsearch.sniffOnConnectionFault'] = false
default['kibana']['config']['prometheus_url'] = 'http://localhost'
default['kibana']['config']['message_format'] = 'Warning: TPS exceeded on these apps: %s. Please ask app group owner to increase TPS.'

default['kibana']['config']['security'] = {
  "password" => "BOOTSTRAP_PASSWORD_CHANGE_ME", 
  "username" => "kibana", 
  "verificationMode" => "none", 
  "xpack.security.enabled" => false
}

default['nginx']['default_site_enabled'] = false
default['nginx']['user'] = node['kibana']['service_user']
default['nginx']['kibana_path'] = '/etc/nginx/conf.d/kibana.conf'
default['nginx']['ip_address'] = '0.0.0.0'
default['nginx']['port'] = 80

# Attributes for registering this service to consul
default['kibana']['consul']['config_dir'] = '/opt/consul/etc'
default['kibana']['consul']['bin'] = '/opt/bin/consul'
default['consul']['cli_opts'] = {
  'config-dir' => default['kibana']['consul']['config_dir'],
  'enable-script-checks' => nil,
  'advertise' => node['ipaddress']
}

# Attributes for elasalert
default['elastalert']['repository'] = 'https://github.com/Yelp/elastalert.git'
default['elastalert']['version'] = 'v0.2.4'

default['elastalert']['elasticsearch']['hostname'] = 'localhost'
default['elastalert']['elasticsearch']['port'] = 9200
default['elastalert']['elasticsearch']['index'] = 'elastalert_status'
default['elastalert']['elasticsearch']['index_old'] = ''
default['elastalert']['elasticsearch']['url_prefix'] = ''
default['elastalert']['elasticsearch']['create_index_opts'] = '--no-auth --no-ssl'
default['elastalert']['elasticsearch']['run_every']['unit'] = 'minutes'
default['elastalert']['elasticsearch']['run_every']['value'] = 1
default['elastalert']['elasticsearch']['buffer_time']['unit'] = 'minutes'
default['elastalert']['elasticsearch']['buffer_time']['value'] = 15
default['elastalert']['elasticsearch']['alert_time_limit']['unit'] = 'days'
default['elastalert']['elasticsearch']['alert_time_limit']['value'] = 2
default['elastalert']['log_dir'] = '/var/log/elastalert'

default['elastalert']['user'] = 'elastalert'
default['elastalert']['user_home'] = "/home/#{node['elastalert']['user']}"
default['elastalert']['group'] = 'elastalert'
default['elastalert']['directory'] = '/opt/elastalert'
default['elastalert']['rules_directory'] = "#{node['elastalert']['directory']}/rules"
default['elastalert']['virtualenv']['directory'] = "#{node['elastalert']['directory']}/.env"

default['elastalert']['supervisor']['logfile'] = "#{node['elastalert']['log_dir']}/elastalert_supervisord.log"
default['elastalert']['supervisor']['logfile_maxbytes'] = '1MB'
default['elastalert']['supervisor']['logfile_backups'] = 2
default['elastalert']['supervisor']['err_logfile'] = "#{node['elastalert']['log_dir']}/elastalert_stderr.log"
default['elastalert']['supervisor']['err_logfile_maxbytes'] = '5MB'
default['elastalert']['supervisor']['run_command'] = "#{node['elastalert']['virtualenv']['directory']}/bin/elastalert --config #{node['elastalert']['directory']}/config.yml --verbose"