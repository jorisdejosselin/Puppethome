# Class for basic Linux config in my env
class profile::base::base_linux (
  $pack_rhel      =  lookup('profile::base::base_linux::pack_rhel', {value_type  =>  Tuple,  default_value  =>  ['nano','vim','epel-release']}),
  $pack_rhel_after  =  lookup('profile::base::base_linux::pack_rhel', {value_type  =>  Tuple,  default_value  =>  ['htop','python','cifs-utils','nfs-utils','sshpass','git','iptables-services']}),
  $pack_deb      =  lookup('profile::base::base_linux::pack_DEB', {value_type  =>  Tuple,  default_value  =>  ['vim','nano','openssh-server','python','cifs-utils','sshpass','git','iptables-persistent']}),
  ){
  #for creating a dir with scripts
  file { '/home/scripts':
    ensure =>  'directory',
  }
  file { '/usr/bin/puppet':
    ensure =>  link,
    target =>  '/opt/puppetlabs/bin/puppet',
  }
  file { '/usr/bin/r10k':
    ensure =>  link,
    target =>  '/opt/puppetlabs/bin/r10k',
  }
  file { '/usr/bin/facter':
    ensure =>  link,
    target =>  '/opt/puppetlabs/bin/facter',
  }
  file { '/usr/bin/mco':
    ensure =>  link,
    target =>  '/opt/puppetlabs/bin/mco',
  }
  file { '/usr/bin/hiera':
    ensure =>  link,
    target =>  '/opt/puppetlabs/bin/hiera',
  }
  file { '/usr/bin/ruby':
    ensure =>  link,
    target =>  '/opt/puppetlabs/puppet/bin/ruby',
  }
  file {'/mnt/data':
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
    content =>  'user=puppet\npass=Test2018!\ndomain=alien\n',
  }
  if $facts[os][family] == 'Redhat' {
    package { $pack_rhel:
      ensure   =>  present,
      provider =>  'yum',
    } -> package { $pack_rhel_after:
      ensure   =>  present,
      provider =>  'yum',
    } ~> mount {'/mnt/data':
    ensure  => 'mounted',
    device  => '//alien/puppetshare',
    atboot  => true,
    fstype  => 'cifs',
    options => 'auto,credentials=/securedir/.sambacredentialsfile',
    require => [File['/securedir/.sambacredentialsfile'],File['/mnt/data']]
  }
  }
  if $facts[os][family] == 'Debian' {
    Package { $pack_deb:
      ensure   =>  present,
      provider =>  'apt',
    } ~> mount {'/mnt/data':
    ensure  => 'mounted',
    device  => '//alien/puppetshare',
    atboot  => true,
    fstype  => 'cifs',
    options => 'auto,credentials=/securedir/.sambacredentialsfile',
    require => [File['/securedir/.sambacredentialsfile'],File['/mnt/data']]
  }
  }
}
