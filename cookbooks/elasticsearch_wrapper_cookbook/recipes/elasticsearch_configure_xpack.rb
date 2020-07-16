version = node['elasticsearch']['version']
ca = node['elasticsearch']['security']['ca']
key_name = node['elasticsearch']['security']['xpack_security_transport_ssl_keystore_path']
xpack_enabled = node['elasticsearch']['security']['xpack_security_enabled']
bootstrap_password = Base64.decode64(node['elasticsearch']['security']['bootstrap_password'])

if xpack_enabled && version >= '7.0.0' && version < '8.0.0'
  file '/usr/share/elasticsearch/ca.p12' do
    action :delete
  end

  file '/usr/share/elasticsearch/elastic-certificates.p12' do
    action :delete
  end

  file '/tmp/ca.b64' do
    content "#{ca}"
    action :create
  end

  apt_package 'expect' do
    action :install
  end
  
  bash 'Setup certificate' do
    user 'root'
    code <<-EOF
      base64 -di '/tmp/ca.b64' >> /usr/share/elasticsearch/ca.p12
      /usr/bin/expect -c 'spawn /usr/share/elasticsearch/bin/elasticsearch-certutil cert --ca /usr/share/elasticsearch/ca.p12 --out /usr/share/elasticsearch/elastic-certificates.p12 --pass "" -s
      match_max 100000
      expect -exact "Enter password for CA (/usr/share/elasticsearch/ca.p12) : "
      send -- "\r"
      expect eof'
      mv /usr/share/elasticsearch/elastic-certificates.p12 /etc/elasticsearch/#{key_name}
      chown elasticsearch:elasticsearch /etc/elasticsearch/#{key_name}
    EOF
  end

  bash 'Setup initial password' do
    user 'root'
    code <<-EOF
      echo "#{bootstrap_password}" | /usr/share/elasticsearch/bin/elasticsearch-keystore add -x "bootstrap.password"
      chown elasticsearch:elasticsearch /etc/elasticsearch/elasticsearch.keystore
    EOF
  end
end