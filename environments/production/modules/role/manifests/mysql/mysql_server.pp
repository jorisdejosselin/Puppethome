# Class: role::mysql::mysql_server
#
#
class role::mysql::mysql_server {
  include profile::base::linux
  include profile::mysql::mysql_server
}
