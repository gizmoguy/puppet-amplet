class amplet::client::install {

  $package_ensure   = $amplet::client::package_ensure
  $package_provider = $amplet::client::package_provider

  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  package { 'amplet2-client':
    ensure   => $package_ensure,
    name     => 'amplet2-client',
    provider => $package_provider,
    notify   => Class['amplet::client::service'],
  }

  Exec["apt-update"] -> Package <| ensure == latest |>

}
