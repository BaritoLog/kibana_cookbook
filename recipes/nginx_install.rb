apt_update 'update_to_install_nginx'
package 'nginx'

apt_package 'libnginx-mod-http-lua'
apt_package 'lua-cjson'

template node['nginx']['kibana_path'] do
  source '/default/nginx/nginx.conf.erb'
  variables(
    listen_address: node['nginx']['ip_address'],
    listen_port: node['nginx']['port'],
    server_name: 'kibana',
    kibana_port: node['kibana']['config']['server.port'],
    base_path: node['kibana']['config']['server.basePath'],
    message_format: node['kibana']['config']['message_format'],
    tps_banner_prometheus_query_url: node['kibana']['config']['prometheus_url'] + "/api/v1/query?query=" +
      URI::encode("increase(barito_producer_tps_exceeded_total{app_group=\"#{node['kibana']['config']['server.basePath'][1..-1]}\"}[1m]) > 0")
  )
  notifies :reload, 'service[nginx]'
end

%w[sites-enabled sites-available conf.d].each do |conf_dir|
  file "/etc/nginx/#{conf_dir}/default" do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end

service 'nginx' do
  supports start: true, enable: true, restart: true
  action [:enable, :start]
end
