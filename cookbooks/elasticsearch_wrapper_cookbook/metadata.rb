name 'elasticsearch_wrapper_cookbook'
maintainer 'GO-JEK Engineering'
maintainer_email 'baritolog@go-jek.com'
license 'Apache-2.0'
description 'Installs/Configures elasticsearch_wrapper_cookbook'
long_description 'Installs/Configures elasticsearch_wrapper_cookbook'
version '7.3.0'
chef_version '>= 12.14' if respond_to?(:chef_version)

issues_url 'https://github.com/BaritoLog/elasticsearch_wrapper_cookbook/issues'
source_url 'https://github.com/BaritoLog/elasticsearch_wrapper_cookbook'

depends 'java'
depends 'elasticsearch'
depends 'ark'