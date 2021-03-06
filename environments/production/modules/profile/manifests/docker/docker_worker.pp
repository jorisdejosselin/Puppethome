# documented
class profile::docker::docker_worker (
  $ipaddress_man  =  file('/mnt/data/docker_managerip.txt'),
  $ipaddress    =  $::ipaddress,
  $token      =  file('/mnt/data/docker_token.txt'),
  $imgfront     = 'pythonwebserv_front',
  $imgback      = 'pythonwebserv_back'
  ){
  firewall { '100 allow docker worker communication':
    dport  => [7946],
    proto  => tcp,
    action => accept,
    }
  firewall { '101 allow docker worker communication':
    dport  => [7946],
    proto  => udp,
    action => accept,
    }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
  docker::image { $imgfront:
    ensure      =>  'latest',
    docker_file =>  '/mnt/data/dockerfiles/pythonwebserv_front/Dockerfile',
  }
  docker::image { $imgback:
    ensure      =>  'latest',
    docker_file =>  '/mnt/data/dockerfiles/pythonwebserv_back/Dockerfile',
  }
  include 'docker'
  docker::swarm {'cluster_worker':
    join           => true,
    advertise_addr => $ipaddress,
    listen_addr    => $ipaddress,
    manager_ip     => $ipaddress_man,
    token          => $token,
    require        => Class['profile::base::base_linux']
  }
  docker::registry { 'dockermanager:5000':
    username => 'puppet',
    password => 'test2018'
  }
}
