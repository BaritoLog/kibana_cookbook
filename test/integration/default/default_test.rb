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

describe command('curl -I http://127.0.0.1:5601/app/kibana') do
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

describe command('curl -I http://127.0.0.1/app/kibana') do
  its(:stdout) { should match(%r{HTTP/1.1 200 OK}) }
  its(:stdout) { should match(/kbn-name: kibana/) }
  its(:stdout) { should match(/kbn-version: 7.3.0/) }
end