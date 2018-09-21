# Class: profile::gitlab::gitlab
#
#
class profile::gitlab::gitlab {
  class { 'gitlab':
    external_url => 'https://git.joict.nl',
}
}
