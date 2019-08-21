# frozen_string_literal: true
source 'https://supermarket.chef.io'

cookbook 'systemd', '~> 3.2.3'
cookbook 'prometheus', git: 'https://github.com/BaritoLog/prometheus-cookbook.git'
metadata
