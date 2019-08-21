name 'kibana_cookbook'
maintainer 'GOJEK Engineering'
maintainer_email 'baritolog@go-jek.com'
license 'Apache-2.0'
description 'Installs/Configures Kibana'
long_description 'Installs/Configures Kibana'
version '7.3.0'
supports 'ubuntu'
chef_version '>= 14.1.1' if respond_to?(:chef_version)

issues_url 'https://github.com/BaritoLog/kibana_cookbook/issues'
source_url 'https://github.com/BaritoLog/kibana_cookbook'

depends 'systemd'
