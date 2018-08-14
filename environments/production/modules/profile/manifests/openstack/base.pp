# Class: profile::openstack::base
#
#
class profile::openstack::base (
  $services = ['NetworkManager','firewalld'],
){
  file { '/etc/installopenstack1.sh':
    ensure  => 'present',
    content => template('profile/openstack/installopenstack1.sh.erb'),
  }
  service { $services:
    ensure => 'stopped',
    enable => false
  }
  if $selinux == true  {
    reboot { 'after':
      subscribe => Class['selinux'],
    }
  }
  else {
    notify { "No need to reboot selinux is ${::selinux}":
      ensure => 'present'
    }
  }
  class { selinux:
    mode => 'disabled',
    type => 'targeted',
  }
  exec { '/etc/installopenstack1.sh':
    ensure  => 'present',
    require => File['/etc/installopenstack1.sh'],
  }
}
