class profile::base::base_linux (
	$pack_RHEL			=	lookup('profile::base::base_linux::pack_RHEL', {value_type	=>	Tuple,	default_value	=>	['nano','vim','epel-release']}),
	$pack_RHEL_after	=	lookup('profile::base::base_linux::pack_RHEL', {value_type	=>	Tuple,	default_value	=>	['htop','python','cifs-utils','nfs-utils','sshpass']}),
	$pack_DEB			=	lookup('profile::base::base_linux::pack_DEB', {value_type	=>	Tuple,	default_value	=>	['vim','nano','openssh-server','python','cifs-utils','sshpass']}),
	){
	file { '/usr/bin/puppet':
		ensure	=>	link,
		target	=>	"/opt/puppetlabs/bin/puppet",
	}
	file { '/usr/bin/facter':
		ensure	=>	link,
		target	=>	"/opt/puppetlabs/bin/facter",
	}
	file { '/usr/bin/mco':
		ensure	=>	link,
		target	=>	"/opt/puppetlabs/bin/mco",
	}
	file { '/usr/bin/hiera':
		ensure	=>	link,
		target	=>	"/opt/puppetlabs/bin/hiera",
	}
	file { '/usr/bin/ruby':
		ensure	=>	link,
		target	=>	"/opt/puppetlabs/puppet/bin/ruby",
	}
	file {'/mnt/data':
		ensure	=> 'directory',
	}
	file {'/securedir/':
		owner   => root,
		group   => root,
		mode    => "644",
		ensure	=> 'directory',
	}
	file { "/securedir/.sambacredentialsfile":
		owner   => root,
		group   => root,
		mode    => "644",
		ensure  => present,
		content =>  "user=puppet\npass=Test2018!\ndomain=alien\n",
	}
	if $facts[os][family] == 'Redhat' {
		Package { $pack_RHEL:
			ensure		=>	present,
			provider	=>	'yum',
		} ->
		Package { $pack_RHEL_after:
			ensure		=>	present,
			provider	=>	'yum',
		} ~>
	mount {"/mnt/data":
		device 		=> "//alien/puppetshare",
		atboot 		=> "true",
		ensure 		=> "mounted",
		fstype 		=> "cifs",
		options 	=> "auto,credentials=/securedir/.sambacredentialsfile",
		require 	=> [File["/securedir/.sambacredentialsfile"],File['/mnt/data']]
	}
	}
	if $facts[os][family] == 'Debian' {
		Package { $pack_DEB:
			ensure		=>	present,
			provider	=>	'apt',
		} ~>
	mount {"/mnt/data":
		device 		=> "//alien/puppetshare",
		atboot 		=> "true",
		ensure 		=> "mounted",
		fstype 		=> "cifs",
		options 	=> "auto,credentials=/securedir/.sambacredentialsfile",
		require 	=> [File["/securedir/.sambacredentialsfile"],File['/mnt/data']]
	}
	}
}