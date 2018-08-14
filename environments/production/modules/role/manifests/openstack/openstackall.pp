# Class: role::openstack::openstackall
#
#
class role::openstack::openstackall {
  include ::ntp
  include ::profile::openstack::base
  include ::openstack::role::allinone
}
