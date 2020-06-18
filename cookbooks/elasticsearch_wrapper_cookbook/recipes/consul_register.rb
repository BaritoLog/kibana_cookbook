#
# Cookbook:: elasticsearchwrapper
# Recipe:: consul_register
#
# Copyright:: 2018, BaritoLog.
#
#

config = {
  "id": "#{node['hostname']}-elasticsearch",
  "name": "elasticsearch",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node['elasticsearch']['port'],
  "meta": {
    "http_schema": "http"
  }
}


checks = [
  {
    "id": "#{node['hostname']}-hc-tcp",
    "name": "elasticsearch",
    "tcp": "#{node['ipaddress']}:#{node['elasticsearch']['port']}",
    "interval": "10s",
    "timeout": "1s"
  }
  # {
  #   "id": "#{node['hostname']}-hc-payload",
  #   "name": "elasticsearch",
  #   "http": "http://#{node['ipaddress']}:#{node['elasticsearch']['port']}",
  #   "tls_skip_verify": false,
  #   "method": "GET",
  #   "header": {},
  #   "interval": "60s",
  #   "timeout": "15s"
	#   }
]

consul_register_service "elasticsearch" do
  config config
  checks checks
  config_dir  node['elasticsearch']['consul']['config_dir']
  consul_bin  node['elasticsearch']['consul']['bin']
end
