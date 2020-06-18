#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_config
#
# Copyright:: 2018, BaritoLog.
#
#

Chef::Recipe.send(:include, HostProperties)
hostname = node.hostname
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

directory data_dir do
  owner user
  group user
  action :create
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
  'thread_pool.bulk.size' => bulk_size_conf,
  'thread_pool.bulk.queue_size' => bulk_queue_size,
  'action.auto_create_index' => auto_create_index,
  'discovery.zen.minimum_master_nodes' => minimum_master_nodes,
  'cluster.routing.allocation.disk.watermark.low' => routing_allocation_disk_watermark_low_threshold,
  'cluster.routing.allocation.disk.watermark.high' => routing_allocation_disk_watermark_high_threshold,
  'cluster.routing.allocation.disk.watermark.flood_stage' => routing_allocation_disk_watermark_flood_stage_threshold,
}

if node_master
  config['cluster.name'] = cluster_name
  config['node.master'] = node_master
  config['discovery.zen.ping.unicast.hosts'] = member_hosts
  config['network.host'] = node.ipaddress
elsif node_data
  config['cluster.name'] = cluster_name
  config['node.data'] = node_data
  config['network.host'] = node.ipaddress
  config['node.master'] = node_master
else
  config['network.host'] = hostname
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
