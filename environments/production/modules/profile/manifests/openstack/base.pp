# Class: profile::openstack::base
#
#
class profile::openstack::base {
  include selinux
  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  }
}
