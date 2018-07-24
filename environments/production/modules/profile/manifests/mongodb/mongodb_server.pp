# documented
class profile::mongodb::mongodb_server (
  ){
  class {'mongodb::client':} -> class {'mongodb::server':
    port    => 27018,
    verbose => true,
  } ~> mongodb::db { 'keystone':
      user          => 'joris',
      password_hash => '0b5c29832d4a421fe29295bd99ff1379',
    }
}
