# Add some things for Puppetmaster now only firewall
class profile::puppet::puppetmaster {
  firewall { '100 allow api access':
    dport  => [8080],
    proto  => tcp,
    action => accept,
    }
  firewall { '200 allow api access':
    dport  => [8080],
    proto  => udp,
    action => accept,
    }
}
