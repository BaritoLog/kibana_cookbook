#
# Cookbook:: elasticsearchwrapper
# Attribute:: default
#
# Copyright:: 2018, BaritoLog.
#
#

# User of elasticsearch process
default['elasticsearch']['user'] = 'elasticsearch'

# Elasticsearch configuration
default['elasticsearch']['version'] = '6.3.0'
default['elasticsearch']['port'] = 9200
default['elasticsearch']['auto_create_index'] = true
default['elasticsearch']['data_directory'] = '/var/lib/elasticsearch'
default['elasticsearch']['bulk_queue_size'] = 1000
default['elasticsearch']['allocated_memory'] = nil
default['elasticsearch']['max_allocated_memory'] = 30500000
default['elasticsearch']['heap_mem_percent'] = 50
default['elasticsearch']['node_master'] = false
default['elasticsearch']['node_data'] = true
default['elasticsearch']['node_ingest'] = false
default['elasticsearch']['cluster_name'] = "elasticsearch"
default['elasticsearch']['member_hosts'] = ["http://elasticsearch.service.consul"]
default['elasticsearch']['memory_lock'] = false
default['elasticsearch']['minimum_master_nodes'] = 1
default['elasticsearch']['routing_allocation_disk_watermark_low_threshold'] = "100gb"
default['elasticsearch']['routing_allocation_disk_watermark_high_threshold'] = "50gb"
default['elasticsearch']['routing_allocation_disk_watermark_flood_stage_threshold'] = "10gb"

# Explicitly set number of replicas, override this as necessary
# Also you need to explicitly include `elasticsearch_set_replica` recipe
default['elasticsearch']['index_number_of_replicas'] = 3

# Java package to install by platform
default['elasticsearch']['java'] = {
  'centos' => 'java-1.8.0-openjdk-headless',
  'ubuntu' => 'openjdk-11-jdk-headless'
}

# Attributes for registering this service to consul
default['elasticsearch']['consul']['config_dir'] = '/opt/consul/etc'
default['elasticsearch']['consul']['bin'] = '/opt/bin/consul'
default['consul']['cli_opts'] = {
  'config-dir' => default['elasticsearch']['consul']['config_dir'],
  'enable-script-checks' => nil
}
default['elasticsearch']['package_retries'] = nil

# JVM configuration
# {key => value} which gives "key=value" or just "key" if value is nil
default['elasticsearch']['jvm_options'] = {
  '-Xss1m' => '',
  '-XX:CMSInitiatingOccupancyFraction' => 75,
  '-XX:+UseCMSInitiatingOccupancyOnly' => '',
  '-XX:+DisableExplicitGC' => '',
  '-XX:+AlwaysPreTouch' => '',
  '-server' => '',
  '-Djava.awt.headless' => true,
  '-Dfile.encoding' => 'UTF-8',
  '-Djna.nosys' => true,
  '-Dio.netty.noUnsafe' => true,
  '-Dio.netty.noKeySetOptimization' => true,
  '-Dlog4j.shutdownHookEnabled' => false,
  '-Dlog4j2.disable.jmx' => true,
  '-Dlog4j.skipJansi' => true,
  '-XX:+HeapDumpOnOutOfMemoryError' => '',
  '-Djava.io.tmpdir' => '/tmp',

  # Avoid crash when using AVX-512
  # https://github.com/elastic/elasticsearch/issues/31425
  '-XX:UseAVX' => 2
}
