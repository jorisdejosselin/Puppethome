# documented
lass profile::mongodb::mongodb_server (
  ){
  class {'mongodb::server':
    port    => 27018,
    verbose => true,
  }
}
