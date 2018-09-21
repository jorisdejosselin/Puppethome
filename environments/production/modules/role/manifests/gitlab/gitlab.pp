# Class: role::gitlab::gitlab
#
#
class role::gitlab::gitlab {
  if $::facts['kernel'] == 'linux' {
    include role::base::base_linux
    include profile::gitlab::gitlab
  }
  else {
    warning("This role is not supported for ${::facts[kernel]}")
  }
}
