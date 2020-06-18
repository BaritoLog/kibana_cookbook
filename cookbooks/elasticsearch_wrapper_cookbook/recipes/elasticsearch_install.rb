#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_install
#
# Copyright:: 2018, BaritoLog.
#
#

package_retries = node['elasticsearch']['package_retries']
version = node['elasticsearch']['version']
java = node['elasticsearch']['java']

# Update apt packages
apt_update 'update'

# java installation can be intentionally ignored by setting the whole key to ''
unless java.to_s.empty?
  java_package = java[node['platform']]

  if java_package.to_s.empty?
    Chef::Log.warn  "No java specified for the platform #{node['platform']}, "\
                    'java will not be installed'

    Chef::Log.warn  'Please specify a java package name if you want to '\
                    'install java using this cookbook.'
  else
    package java_package do
      retries package_retries unless package_retries.nil?
    end
  end
end

elasticsearch_install 'elasticsearch' do
  type 'package'
  version version
  action :install
end

execute 'apt autoremove' do
  command 'apt autoremove -y'
end