class profile::docker::docker_manager (
    $ipaddress    = $::ipaddress
  ){
  require profile::base::base_linux
  firewall { '100 allow docker worker access':
    dport  => [2377],
    proto  => tcp,
    action => accept,
    }
  file {'/mnt/data/docker_managerip.txt':
    content  =>  $ipaddress,
  }
  file {'/mnt/data/docker_token.txt':
    content  =>  $::facts['docker_token']
  }
  file {'/mnt/data/basehiera.yaml':
    content  =>  "---
classes:
 - profile::base::base_linux"
  }
  file {'/mnt/data/makehieranode.sh':
    ensure  =>  'present',
    content  =>  "sshpass -p 'Test2018!' scp -r /home/joris/scripts/basehiera.yaml root@puppet:/etc/puppetlabs/code/environments/production/data/nodes/$(hostname).yaml
					",
    mode    =>  '0700'
  }

  include 'docker'
  docker::swarm {'cluster_manager':
    init           => true,
    advertise_addr => $ipaddress,
    listen_addr    => $ipaddress,
  }
  docker_network { 'internal':
    ensure  => present
  }
  docker::image { 'pythonwebserv_front':
    ensure      =>  latest,
    docker_file  =>  '/mnt/data/dockerfiles/pythonwebserv_front/Dockerfile'
  }
  docker::image { 'pythonwebserv_back':
    ensure      =>  latest,
    docker_file  =>  '/mnt/data/dockerfiles/pythonwebserv_back/Dockerfile'
  }
  docker::services {'front':
    create       => true,
    service_name => 'front',
    image        => 'pythonwebserv_front',
    publish      => '80:80',
    replicas     => '2',
    extra_params =>  ['--hostname front.test.local','--dns-search test.local','--network internal']
  }
  docker::services {'back':
    create       => true,
    service_name => 'back',
    image        => 'pythonwebserv_back',
    publish      => '8080',
    replicas     => '2',
    extra_params =>  ['--hostname back.test.local','--dns-search test.local','--network internal']
  }
  # docker::run {'registry':
    # ensure				=>	absent,
    # username			=>	'puppet',
    # expose				=>	'5000:5000',
    # image				=>	'registry',
    # extra_parameters	=>	['--password Test2018']
  # }
  # docker::registry { 'dockermanager:5000':
    # ensure	 =>	absent,
    # username => 'puppet',
    # password => 'test2018',
  # }
}