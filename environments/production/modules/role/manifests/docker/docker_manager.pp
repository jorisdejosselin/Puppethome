class role::docker::docker_manager (
		$ipaddress		= $::ipaddress
	){
	firewall { '100 allow docker worker access':
		dport  => [2377],
		proto  => tcp,
		action => accept,
    }
	file {'/mnt/data/docker_managerip.txt':
		content	=>	$ipaddress,
	}
	file {'/mnt/data/docker_token.txt':
		content	=>	$facts['docker_token']
	}
	file {'/mnt/data/basehiera.yaml':
		content	=>	"---
classes:
 - profile::base::base_linux"
	}
	file {'/mnt/data/makehieranode.sh':
		ensure	=>	'present',
		content	=>	"sshpass -p 'Test2018!' scp -r /home/joris/scripts/basehiera.yaml root@puppet:/etc/puppetlabs/code/environments/production/data/nodes/$(hostname).yaml
					",
		mode	=>	"700"
	}
		
	include 'docker'
	docker::swarm {'cluster_manager':
		init           => true,
		advertise_addr => $ipaddress,
		listen_addr    => $ipaddress,
	}
	docker_network { 'puppet':
		ensure	=> present
	}
	docker::image { 'puppet/puppet-agent':
		ensure	=> 'present'
	}
	docker::run { 'puppet-agent':
		ensure			=> 'present',
		image   		=> 'puppet/puppet-agent',
		before_start 	=> 'sshpass -p "Test2018!" scp -r /home/joris/scripts/basehiera.yaml root@puppet:/etc/puppetlabs/code/environments/production/data/nodes/$(hostname).yaml',
	}
	docker::image { 'ubuntu':
		ensure		=> 'present',
		image_tag	=> 'precise'
	}
	docker::run { 'ubuntu':
		ensure		=> 'present',
		image   	=> 'ubuntu',
	}
	docker::image { 'puppet/puppetserver-standalone':
		ensure		=> 'present',
		hostname	=> 'puppet',
	}
	docker::run { 'puppetmaster':
		ensure			=> 'present',
		image   		=> 'puppet/puppetserver-standalone',
		before_start 	=> 'sshpass -p "Test2018!" scp -r /home/joris/scripts/basehiera.yaml root@puppet:/etc/puppetlabs/code/environments/production/data/nodes/$(hostname).yaml',
	}
}