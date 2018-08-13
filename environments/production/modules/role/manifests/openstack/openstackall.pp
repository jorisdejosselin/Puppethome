# Class: role::openstack::openstackall
#
#
class role::openstack::openstackall {
  include ::profile::openstack::base
  include ::openstack::role::controller
  include ::openstack::role::compute
  include ::openstack::role::storage
}
