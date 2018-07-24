# Add some things for Puppetmaster now only firewall
class profile::puppet::puppetmaster {
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
}
