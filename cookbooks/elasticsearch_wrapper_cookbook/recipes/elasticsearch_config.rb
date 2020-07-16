#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_config
#
# Copyright:: 2018, BaritoLog.
#
#

Chef::Recipe.send(:include, HostProperties)
hostname = node['hostname']
version = node['elasticsearch']['version']
ipaddress = node['ipaddress']
port = node['elasticsearch']['port']
bulk_queue_size = node['elasticsearch']['bulk_queue_size']
auto_create_index = node['elasticsearch']['auto_create_index']
data_dir = node['elasticsearch']['data_directory']
node_master = node['elasticsearch']['node_master']
node_data = node['elasticsearch']['node_data']
cluster_name = node['elasticsearch']['cluster_name']
memory_lock = node['elasticsearch']['memory_lock']
jvm_options = node['elasticsearch']['jvm_options'].map do |key, opt|
  "#{key}#{"=#{opt}" unless opt.to_s.empty?}" unless opt == 'nil'
end
member_hosts = node['elasticsearch']['member_hosts']
minimum_master_nodes = node['elasticsearch']['minimum_master_nodes']
routing_allocation_disk_watermark_low_threshold = node['elasticsearch']['routing_allocation_disk_watermark_low_threshold']
routing_allocation_disk_watermark_high_threshold = node['elasticsearch']['routing_allocation_disk_watermark_high_threshold']
routing_allocation_disk_watermark_flood_stage_threshold = node['elasticsearch']['routing_allocation_disk_watermark_flood_stage_threshold']
node_awareness_value = node['elasticsearch']['node_awareness_value']
node_awareness_attribute = node['elasticsearch']['node_awareness_attribute']

directory data_dir do
  owner user
  group user
  action :create
end

if version >= '7.0.0' && version < '8.0.0'
  initial_master_nodes = node['elasticsearch']['initial_master_nodes']
  discovery_seed_hosts = node['elasticsearch']['discovery_seed_hosts']
  xpack_security_enabled = node['elasticsearch']['security']['xpack_security_enabled']
  xpack_security_transport_ssl_enabled = node['elasticsearch']['security']['xpack_security_transport_ssl_enabled']
  xpack_security_transport_ssl_verification_mode = node['elasticsearch']['security']['xpack_security_transport_ssl_verification_mode']
  xpack_security_transport_ssl_keystore_path = node['elasticsearch']['security']['xpack_security_transport_ssl_keystore_path']
  xpack_security_transport_ssl_truststore_path = node['elasticsearch']['security']['xpack_security_transport_ssl_truststore_path']
end

if node['elasticsearch']['allocated_memory']
  elasticsearch_memory = "#{node['elasticsearch']['allocated_memory']/1024}m"
else
  elasticsearch_memory = allocated_memory
end

bulk_size_conf = bulk_size
config = {
  'path.data' => data_dir,
  'node.name' => hostname,
  'http.port' => port,
  'network.host' => hostname,
  'bootstrap.memory_lock' => memory_lock,
  'thread_pool.write.size' => bulk_size_conf,
  'thread_pool.write.queue_size' => bulk_queue_size,
  'action.auto_create_index' => auto_create_index,
  'discovery.zen.minimum_master_nodes' => minimum_master_nodes,
  'cluster.routing.allocation.disk.watermark.low' => routing_allocation_disk_watermark_low_threshold,
  'cluster.routing.allocation.disk.watermark.high' => routing_allocation_disk_watermark_high_threshold,
  'cluster.routing.allocation.disk.watermark.flood_stage' => routing_allocation_disk_watermark_flood_stage_threshold,
  "node.attr.#{node_awareness_attribute}" => node_awareness_value,
}

if node_master
  config['cluster.name'] = cluster_name
  config['node.master'] = node_master
  config['network.host'] = ipaddress
  config['cluster.routing.allocation.awareness.attributes'] = node_awareness_attribute
elsif node_data
  config['cluster.name'] = cluster_name
  config['node.data'] = node_data
  config['network.host'] = ipaddress
  config['node.master'] = node_master
else
  config['network.host'] = hostname
end

if version >= '7.0.0' && version < '8.0.0'
  config['discovery.seed_hosts'] = discovery_seed_hosts
  config['cluster.initial_master_nodes'] = initial_master_nodes
  if xpack_security_enabled
    config['xpack.security.enabled'] = xpack_security_enabled
    config['xpack.security.transport.ssl.enabled'] = xpack_security_transport_ssl_enabled
    config['xpack.security.transport.ssl.verification_mode'] = xpack_security_transport_ssl_verification_mode
    config['xpack.security.transport.ssl.keystore.path'] = xpack_security_transport_ssl_keystore_path
    config['xpack.security.transport.ssl.truststore.path'] = xpack_security_transport_ssl_truststore_path
  end
else
  config['discovery.zen.ping.unicast.hosts'] = member_hosts
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory elasticsearch_memory
  jvm_options jvm_options
  configuration (config)
  action :manage
end

# TODO: this is not working, should be refactored
# limits_config 'elasticsearch' do
#   limits [
#     { domain: 'elasticsearch', type: 'hard', value: 'unlimited', item: 'memlock' },
#     { domain: 'elasticsearch', type: 'soft', value: 'unlimited', item: 'memlock' }
#   ]
# end

sysctl 'vm.max_map_count' do
  key 'vm.max_map_count'
  value 262_144
  action :apply
end

link '/usr/share/elasticsearch/config' do
  to '/etc/elasticsearch/'
end
