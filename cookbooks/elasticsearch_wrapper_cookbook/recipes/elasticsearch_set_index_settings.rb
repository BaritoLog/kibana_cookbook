#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_set_replica
#
# Copyright:: 2018, BaritoLog.
#
#

port = node['elasticsearch']['port']
ipaddress = node['ipaddress']
xpack_enabled = node['elasticsearch']['security']['xpack_security_enabled']
number_of_shards = node['elasticsearch']['index_number_of_shards']
number_of_replicas = node['elasticsearch']['index_number_of_replicas']
refresh_interval = node['elasticsearch']['index_refresh_interval']
bootstrap_password = Base64.decode64(node['elasticsearch']['security']['bootstrap_password'])
basic_auth = Base64.encode64("elastic:#{bootstrap_password}")
# Since ES >= 5, index configuration cannot using yaml file, using dynamic config API instead

if xpack_enabled
  http_request 'Create default template' do
    url "http://#{ipaddress}:#{port}/_template/index_settings"
    action :put
    headers({'AUTHORIZATION' => "Basic #{basic_auth}",
      'Content-Type' => 'application/json'
    })
    message "{ \"index_patterns\": [\"*\"], \"order\": 0, \"settings\": { \"number_of_shards\": \"#{number_of_shards}\", \"number_of_replicas\": \"#{number_of_replicas}\", \"refresh_interval\": \"#{refresh_interval}\" }}"
    retry_delay 30
    retries 10
  end

  # Update old index, might be error because new node have empty index, ignored
  http_request 'Change number_of_replicas in existing index' do
    url "http://#{ipaddress}:#{port}/_settings"
    action :put
    headers({'AUTHORIZATION' => "Basic #{basic_auth}",
      'Content-Type' => 'application/json'
    })
    message "{\"index\": {\"refresh_interval\": \"#{refresh_interval}\" }}"
    retry_delay 30
    ignore_failure true
  end
else
  http_request 'Create default template' do
    url "http://#{ipaddress}:#{port}/_template/index_settings"
    action :put
    headers 'Content-Type' => 'application/json'
    message "{ \"index_patterns\": [\"*\"], \"order\": 0, \"settings\": { \"number_of_shards\": \"#{number_of_shards}\", \"number_of_replicas\": \"#{number_of_replicas}\", \"refresh_interval\": \"#{refresh_interval}\" }}"
    retry_delay 30
    retries 10
  end

  # Update old index, might be error because new node have empty index, ignored
  http_request 'Change number_of_replicas in existing index' do
    url "http://#{ipaddress}:#{port}/_settings"
    action :put
    headers 'Content-Type' => 'application/json'
    message "{\"index\": {\"refresh_interval\": \"#{refresh_interval}\" }}"
    retry_delay 30
    ignore_failure true
  end
end