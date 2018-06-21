class role::nginx::nginx_base {
        firewall { '100 allow http and https access':
			dport  => [80, 443],
			proto  => tcp,
			action => accept,
        }
		class{'nginx':
			manage_repo 	=> true,
			package_source 	=> 'nginx-mainline'
		}
		class { ::letsencrypt:
			email => 'j.j.dejosselindejong@gmail.com',
		}
		letsencrypt::certonly { 'Apply certs':
			domains 				=> ['jorisdejosselindejong.nl', 'owncloud.jorisdejosselindejong.nl'],
			manage_cron 			=> true,
			cron_before_command 	=> 'systemctl stop nginx',
			cron_success_command 	=> 'systemctl restart nginx',
			suppress_cron_output 	=> true,
		}
		nginx::resource::server { 'test.jorisdejosselindejong.nl':
			listen_port => 80,
			proxy       => 'http://localhost:3000',
		}
		nginx::resource::server { 'test2.jorisdejosselindejong.nl':
			listen_port => 80,
			proxy       => 'http://localhost:60000',
		}
}
