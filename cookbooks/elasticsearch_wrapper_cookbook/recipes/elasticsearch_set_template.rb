#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_template
#
# Copyright:: 2018, BaritoLog.
#
#
require 'json'
version = node['elasticsearch']['version']
ipaddress = node['ipaddress']
xpack_enabled = node['elasticsearch']['security']['xpack_security_enabled']
bootstrap_password = Base64.decode64(node['elasticsearch']['security']['bootstrap_password'])
override_base_template = node['elasticsearch']['override_base_template']
basic_auth = Base64.encode64("elastic:#{bootstrap_password}")

if override_base_template
  base_template = node['elasticsearch']['base_template']
elsif version >= '6.0.0' && version < '7.0.0'
  base_template = node['elasticsearch']['base_template_es6']
elsif version >= '7.0.0' && version < '8.0.0'
  base_template = node['elasticsearch']['base_template_es7']
else
  base_template = node['elasticsearch']['base_template']
end

port = node['elasticsearch']['port']

if xpack_enabled
  http_request 'Create base template' do
    url "http://#{ipaddress}:#{port}/_template/base_template"
    action :put
    headers({'AUTHORIZATION' => "Basic #{basic_auth}",
      'Content-Type' => 'application/json'
    })
    message(base_template.to_json)
    ignore_failure true
    retry_delay 30
    retries 10
  end
else
  http_request 'Create base template' do
    url "http://#{ipaddress}:#{port}/_template/base_template"
    action :put
    headers 'Content-Type' => 'application/json'
    message(base_template.to_json)
    ignore_failure true
    retry_delay 30
    retries 10
  end
end