#
# Cookbook:: kibana
# Recipe:: consul_register
#
# Copyright:: 2020, BaritoLog.
#
#

config = {
  "id": "#{node['hostname']}-kibana",
  "name": "kibana",
  "tags": ["app:"],
  "address": node['ipaddress'],
  "port": node['nginx']['port'],
  "meta": {
    "http_schema": "http"
  }
}

checks = [
  {
    "id": "#{node['hostname']}-kibana-hc-tcp",
    "name": "kibana",
    "tcp": "localhost:#{node['kibana']['config']['port']}",
    "interval": "10s",
    "timeout": "1s"
  },
  {
    "id": "#{node['hostname']}-hc-http",
    "name": "kibana",
    "http": "http://localhost:#{node['kibana']['config']['port']}",
    "tls_skip_verify": false,
    "method": "GET",
    "header": {},
    "interval": "60s",
    "timeout": "15s"
  },
]

consul_register_service "kibana" do
  config config
  config_dir  node['kibana']['consul']['config_dir']
  consul_bin  node['kibana']['consul']['bin']
end
