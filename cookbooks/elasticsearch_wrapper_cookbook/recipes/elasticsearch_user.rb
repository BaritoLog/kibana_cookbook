#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_user
#
# Copyright:: 2018, BaritoLog.
#
#

user = node['elasticsearch']['user']

elasticsearch_user user do
  action :create
end
