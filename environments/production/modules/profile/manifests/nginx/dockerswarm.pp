# Class: profile::nginx::dockerswarm
#
#
class profile::nginx::dockerswarm {
  class { 'nginx': }
  nginx::resource::upstream { 'docker_swarm_app':
  members => [
    'dockermanager:80',
    'worker1:80',
  ],
}
}
