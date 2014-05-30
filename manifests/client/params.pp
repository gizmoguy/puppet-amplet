  # Class: amplet::client::params
#
#   The amplet-client configuration settings.
#
class amplet::client::params {

  case $::osfamily {
    'Debian': {
      $package_ensure   = 'installed'
      $package_provider = 'apt'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  $ampname          = $::clientcert
  $ampcollector     = 'localhost'
  $service_config   = 'amplet/client/default.erb'
  $service_path     = '/etc/defaults/amplet2-client'
  $config           = 'amplet/client/client.conf.erb'
  $config_path      = "/etc/amplet2/clients/${ampname}.conf"
  $nametable_config = 'amplet/client/nametable.erb'
  $nametable_path   = "/etc/amplet2/nametables/${ampname}"
  $schedule_config  = 'amplet/client/schedule.erb'
  $schedule_path    = "/etc/amplet2/schedules/${ampname}"
  $keys_path        = "/etc/amplet2/keys/${ampname}"
  $cacert           = ''
  $cert             = ''
  $key              = ''

}
