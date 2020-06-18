#
# Cookbook:: elasticsearchwrapper
# Recipe:: elasticsearch_systemd
#
# Copyright:: 2018, BaritoLog.
#
#

elasticsearch_service 'elasticsearch' do
  service_actions %i[start enable restart]
end