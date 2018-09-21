# Class: profile::gitlab::gitlab
#
#
class profile::gitlab::gitlab {
  firewall { '100 allow docker worker access':
    dport  => [80],
    proto  => tcp,
    action => accept,
  }
  firewall { '101 allow docker worker access':
    dport  => [443],
    proto  => tcp,
    action => accept,
  }
  class { 'gitlab':
    external_url => 'https://git.joict.nl',
  }
}
