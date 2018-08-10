# Add some things for Puppetmaster now only firewall
class profile::puppet::puppetmaster (
  $dir = '/home/admin/scripts/deployment/__main__.py'
){
  firewall { '001 Allow inbound SSH':
    dport  => 22,
    proto  => tcp,
    action => accept,
  }
  firewall { '002 Allow inbound SSH':
    dport  => 22,
    proto  => udp,
    action => accept,
  }
  firewall { '003 Allow inbound SSH':
    dport  => 8140,
    proto  => tcp,
    action => accept,
  }
  firewall { '100 allow api access':
    dport  => [8081],
    proto  => tcp,
    action => accept,
    }
  firewall { '200 allow api access':
    dport  => [8081],
    proto  => udp,
    action => accept,
    }
  firewall { '999 drop all other requests':
    action => 'drop',
  }
  file { '/etc/systemd/system/deploy.service':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.service.erb'),
    }
  file { '/home/admin/scripts/deployment/deploy.sh':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.sh.erb'),
    }
  file { '/home/admin/scripts/deployment/__main__.py':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/puppetmaster/deploy.py.erb'),
    }
  exec { 'myservice-systemd-reload':
      command     => 'systemctl daemon-reload',
      path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
      refreshonly => true,
      require     => [ File['/etc/systemd/system/deploy.service'], File['/home/admin/scripts/deployment/deploy.sh'] , File['/home/admin/scripts/deployment/__main__.py'] ]
    }
  service { 'deploy':
      ensure  => running,
      require => Exec['myservice-systemd-reload'],
    }
}
