# Class: profile::nginx::letsencrypt
#
#
class profile::nginx::letsencrypt {
  file {'/mnt/nginx':
    ensure => 'directory',
  }
  file {'/securedir/':
    ensure => 'directory',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { '/securedir/.sambacredentialsfile':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => 'user=certbot\npass=Test2018!\ndomain=alien\n',
  }
  mount {'/mnt/data':
    ensure  => 'mounted',
    device  => '//192.168.178.1/nginx',
    atboot  => true,
    fstype  => 'nfs',
    options => 'auto,credentials=/securedir/.sambacredentialsfile',
    require => [File['/securedir/.sambacredentialsfile'],File['/mnt/data']]
  }
  letsencrypt::certonly{ 'domains':
    domains              => ['router.joict.nl', 'mail.jorisdejosselindejong.nl'],
    manage_cron          => false,
    cron_before_command  => 'sshpass -p "Test2018!" ssh root@192.168.178.1 && service nginx stop',
    cron_success_command => 'sshpass -p "Test2018!" ssh root@192.168.178.1 && /bin/systemctl reload nginx.service',
    suppress_cron_output => true,
    require              => Mount['/mnt/data'],
  }
}
