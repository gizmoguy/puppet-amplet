  # Class: amplet::server::params
#
#   The amplet-server configuration settings.
#
class amplet::server::params {

  case $::osfamily {
    'Debian': {
      $package_ensure   = 'installed'
      $package_provider = 'apt'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  $cacert           = ''
  $cert             = ''
  $key              = ''

}
