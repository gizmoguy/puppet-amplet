  #
class amplet::client (
  $ampname          = $amplet::client::params::ampname,
  $ampcollector     = $amplet::client::params::ampcollector,
  $service_config   = $amplet::client::params::service_config,
  $service_path     = $amplet::client::params::service_path,
  $config           = $amplet::client::params::config,
  $config_path      = $amplet::client::params::config_path,
  $nametable_config = $amplet::client::params::nametable_config,
  $nametable_path   = $amplet::client::params::nametable_path,
  $schedule_config  = $amplet::client::params::schedule_config,
  $schedule_path    = $amplet::client::params::schedule_path,
  $package_ensure   = $amplet::client::params::package_ensure,
  $package_provider = $amplet::client::params::package_provider,
  $cacert           = $amplet::client::params::cacert,
  $cert             = $amplet::client::params::cert,
  $key              = $amplet::client::params::key,
  $packetdelay      = $amplet::client::params::packetdelay,
  $nameservers      = $amplet::client::params::nameservers,
) inherits amplet::client::params {

  validate_string($ampname)
  validate_string($ampcollector)
  validate_string($service_config)
  validate_absolute_path($service_path)
  validate_string($config)
  validate_absolute_path($config_path)
  validate_string($nametable_config)
  validate_absolute_path($nametable_path)
  validate_string($schedule_config)
  validate_absolute_path($schedule_path)
  validate_string($package_ensure)
  validate_string($package_provider)
  validate_string($cacert)
  validate_string($cert)
  validate_string($key)
  validate_string($packetdelay)
  validate_array($nameservers)

  include '::amplet::client::cleanup'
  include '::amplet::client::install'
  include '::amplet::client::config'
  include '::amplet::client::service'

  case $::osfamily {
    'Debian':
      { include '::amplet::repo::apt' }
    default:
      { }
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'amplet::client::begin': }
  anchor { 'amplet::client::end': }

  Anchor['amplet::client::begin'] -> Class['::amplet::client::cleanup']
    -> Class['::amplet::client::install'] -> Class['::amplet::client::config']
    ~> Class['::amplet::client::service'] -> Anchor['amplet::client::end']

}
