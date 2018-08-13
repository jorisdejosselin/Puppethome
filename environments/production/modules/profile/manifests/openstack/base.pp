# Class: profile::openstack::base
#
#
class profile::openstack::base {
  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  }
  reboot { 'after':
    subscribe       => Class['selinux'],
  }
}
