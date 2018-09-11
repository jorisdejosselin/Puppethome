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
  }
  nginx::resource::server { "jorisdejosselindejong.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:3000',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/jorisdejosselindejong.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/jorisdejosselindejong.nl/privkey.pem',
  }
  nginx::resource::server { "owncloud.jorisdejosselindejong.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:60000',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/jorisdejosselindejong.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/jorisdejosselindejong.nl/privkey.pem',
  }
  nginx::resource::server { "monitoring.jorisdejosselindejong.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:19999',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/jorisdejosselindejong.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/jorisdejosselindejong.nl/privkey.pem',
  }
  nginx::resource::upstream { 'cloud':
  members => [
    '192.168.178.118:80',
    '192.168.178.117:80',
  ],
}
  nginx::resource::server { "cloud.jorisdejosselindejong.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://cloud',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/jorisdejosselindejong.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/jorisdejosselindejong.nl/privkey.pem',
  }
  nginx::resource::server { "joict.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:3000',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/joict.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/joict.nl/privkey.pem',
  }
  nginx::resource::server { "owncloud.joict.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:60000',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/joict.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/joict.nl/privkey.pem',
  }
  nginx::resource::server { "monitoring.joict.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://192.168.178.101:19999',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/joict.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/joict.nl/privkey.pem',
  }
  nginx::resource::server { "cloud.joict.nl":
    ensure                => present,
    listen_port           => 443,
    proxy                 => 'http://cloud',
    ssl                   => true,
    ssl_only              => true,
    ssl_cert              => '/etc/letsencrypt/live/joict.nl/fullchain.pem',
    ssl_key               => '/etc/letsencrypt/live/joict.nl/privkey.pem',
  }
}
