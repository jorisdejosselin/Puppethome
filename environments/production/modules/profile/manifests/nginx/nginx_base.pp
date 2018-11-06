# For adding nginx to my server
class profile::nginx::nginx_base {
  firewall { '100 allow http and https access':
    dport  => [80, 443],
    proto  => tcp,
    action => accept,
      }
  file { '/etc/nginx/sites-enabled/joorsite':
    ensure => file,
    content => template('profile/nginx/nginx.conf.erb');
  }
  package { 'certbot-nginx':
    ensure => installed,
  }
  package { 'nginx':
    ensure => installed,
  }
}
