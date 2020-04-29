kibana_install 'kibana' do
  version node['kibana']['version']
  base_dir node['kibana']['config']['base_dir']
  user node['kibana']['user']
end

kibana_config 'kibana' do
  configuration 'server.port' => node['kibana']['config']['server.port'],
                'server.host' => node['kibana']['config']['server.host'],
                'server.basePath' => node['kibana']['config']['server.basePath'],
                'elasticsearch.url' => node['kibana']['config']['elasticsearch.url'],
                'elasticsearch.hosts' => node['kibana']['config']['elasticsearch.hosts'],
                'elasticsearch.sniffInterval' => node['kibana']['config']['elasticsearch.sniffInterval'],
                'elasticsearch.sniffOnStart' => node['kibana']['config']['elasticsearch.sniffOnStart'],
                'elasticsearch.sniffOnConnectionFault' => node['kibana']['config']['elasticsearch.sniffOnConnectionFault'],
                'logging.dest' => node['kibana']['config']['logging.dest'],
    			'xpack.security.enabled' => node['kibana']['config']['xpack.security.enabled']
end

include_recipe "kibana::nginx_install"

service 'kibana' do
  supports start: true, restart: true, stop: true, status: true
  action [:enable, :restart]
end