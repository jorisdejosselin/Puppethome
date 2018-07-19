# For adding nginx to my server
class profile::nginx::nginx_base {
    firewall { '100 allow http and https access':
      dport  => [80, 443],
      proto  => tcp,
      action => accept,
        }
    class{'nginx':
      manage_repo    => true,
      package_source => 'nginx-mainline'
    }
    class { ::letsencrypt:
      email => 'j.j.dejosselindejong@gmail.com',
    }
    letsencrypt::certonly { 'Apply certs':
      domains         => ['jorisdejosselindejong.nl', 'owncloud.jorisdejosselindejong.nl'],
      manage_cron       => true,
      cron_before_command   => 'systemctl stop nginx',
      cron_success_command   => 'systemctl restart nginx',
      suppress_cron_output   => true,
    }
    nginx::resource::server { 'test.jorisdejosselindejong.nl':
      listen_port => 80,
      proxy       => 'http://localhost:3000',
    }
    nginx::resource::server { 'test2.jorisdejosselindejong.nl':
      listen_port => 80,
      proxy       => 'http://localhost:60000',
    }
    file { '/lib/systemd/system/phpscript.service':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('profile/nginx/updateip.erb'),
    }
    exec { 'myservice-systemd-reload':
      command     => 'systemctl daemon-reload',
      path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
      refreshonly => true,
      require     => file['/lib/systemd/system/phpscript.service'],
    }
    service { 'phpscript':
      ensure  => running,
      require => exec['myservice-systemd-reload'],
    }
}
