class role::nginx::nginx_base {
        firewall { '100 allow http and https access':
			dport  => [80, 443],
			proto  => tcp,
			action => accept,
        }
		class{'nginx':
			manage_repo => true,
			package_source => 'nginx-mainline'
		}

}
