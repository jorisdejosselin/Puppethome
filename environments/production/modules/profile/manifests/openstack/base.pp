# Class: profile::openstack::base
#
#
class profile::openstack::base (
  $services = ['NetworkManager','firewalld'],
){
  file { '/etc/installopenstack.sh':
    ensure  => 'present',
    content => template('profile/openstack/installopenstack.sh.erb'),
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
  exec { 'sh /etc/installopenstack.sh':
    path     => '/usr/bin:/usr/sbin:/bin',
    provider => shell,
    require  => File['/etc/installopenstack.sh'],
  }
}
