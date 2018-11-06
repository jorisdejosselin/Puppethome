# For adding nginx to my server
class profile::nginx::nginx_base {
  firewall { '100 allow http and https access':
    dport  => [80, 443],
    proto  => tcp,
    action => accept,
      }
  class {'nginx':
    manage_repo    => true,
    package_source => 'nginx-mainline'
  } -> file { '/etc/nginx/nginx.conf':
    ensure => file,
    source => template('profile/nginx/nginx.conf.erb');
  }
  package { 'certbot':
    ensure => installed,
  }
}
