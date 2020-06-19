# # encoding: utf-8

# Inspec test for recipe pathfinder-node::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

title 'kibana'

unless os.windows?
  describe group('kibana') do
    it { should exist }
  end

  describe user('kibana')  do
    it { should exist }
  end
end

describe systemd_service('kibana') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/logrotate.d/kibana') do
its('mode') { should cmp '0644' }
end

describe port(5601) do
  it { should be_listening }
end

describe file('/var/log/kibana.log') do
  it { should be_file }
  it { should be_owned_by 'kibana' }
  it { should be_grouped_into 'kibana' }
  its('mode') { should cmp '0644' }
end

describe command('curl -I http://192.168.33.10/test_cluster/app/kibana') do
  its(:stdout) { should match(%r{HTTP/1.1 200 OK}) }
  its(:stdout) { should match(/kbn-name: kibana/) }
end

title 'nginx'

describe systemd_service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command('curl -I http://192.168.33.10/test_cluster/app/kibana') do
  its(:stdout) { should match(%r{HTTP/1.1 200 OK}) }
  its(:stdout) { should match(/kbn-name: kibana/) }
end

title 'elastalert'

unless os.windows?
  describe group('elastalert') do
    it { should exist }
  end

  describe user('elastalert')  do
    it { should exist }
  end
end

describe file('/opt/kibana/elastalert_plugin_installed.txt') do
  it { should be_file }
  it { should be_owned_by 'kibana' }
  it { should be_grouped_into 'kibana' }
  it { should exist }
end

describe systemd_service('elastalert_server') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe package('git') do
  it { should be_installed }
end

describe file('/opt/elastalert') do
  it { should be_a_directory }
  it { should be_owned_by 'elastalert' }
  it { should be_grouped_into 'elastalert' }
end

describe file('/opt/elastalert') do
  it { should be_a_directory }
  it { should be_owned_by 'elastalert' }
  it { should be_grouped_into 'elastalert' }
end

describe file('/opt/elastalert-server') do
  it { should be_a_directory }
  it { should be_owned_by 'elastalert' }
  it { should be_grouped_into 'elastalert' }
end

describe port(3030) do
  it { should be_listening }
end
