default['kibana']['url'] = nil
default['kibana']['checksum'] = nil

default['kibana']['version'] = '6.8.5'
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
default['kibana']['config']['elastalert-kibana-plugin.serverHost'] = 'localhost'
default['kibana']['config']['elastalert-kibana-plugin.serverPort'] = '3030'
default['kibana']['config']['elastalert_installed'] = false


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

# Attributes for elasalert_server
default['elastalert_server']['repository'] = 'https://github.com/bitsensor/elastalert.git'
default['elastalert_server']['directory'] = '/opt/elastalert-server'

# Attributes for elasalert
default['elastalert']['repository'] = 'https://github.com/Yelp/elastalert.git'
default['elastalert']['version'] = 'v0.2.4'

default['elastalert']['elasticsearch']['hostname'] = 'elasticsearch.service.consul'
default['elastalert']['elasticsearch']['port'] = 9200
default['elastalert']['elasticsearch']['username'] = ''
default['elastalert']['elasticsearch']['password'] = ''
default['elastalert']['elasticsearch']['hostname'] = 'elasticsearch.service.consul'
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
default['elastalert']['rules_directory'] = "rules"
default['elastalert']['rule_templates_dir'] = "rule_templates"
default['elastalert_plugin']['version'] = '1.0.3'
default['elastalert_plugin']['repo'] = 'https://github.com/bitsensor/elastalert-kibana-plugin'

default['nodejs']['npm']['install_method'] = 'source'
