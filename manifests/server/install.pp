class amplet::server::install {

  $package_ensure   = $amplet::server::package_ensure
  $package_provider = $amplet::server::package_provider

  package { 'amplet2-server':
    ensure   => $package_ensure,
    name     => 'amplet2-server',
    provider => $package_provider
  }

}
