# Class: role::nginx::nginx_dockerswarm
#
#
class role::nginx::nginx_dockerswarm {
  include profile::base::base_linux
  include profile::nginx::dockerswarm
}
