#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch
#
# Copyright:: 2018, BaritoLog.
#
#

# Not doing anything on default cookbook

include_recipe "#{cookbook_name}::elasticsearch_install"
include_recipe "#{cookbook_name}::elasticsearch_user"
include_recipe "#{cookbook_name}::elasticsearch_config"
include_recipe "#{cookbook_name}::elasticsearch_configure_xpack"
include_recipe "#{cookbook_name}::elasticsearch_systemd"
include_recipe "#{cookbook_name}::elasticsearch_set_template"
include_recipe "#{cookbook_name}::elasticsearch_set_index_settings"
