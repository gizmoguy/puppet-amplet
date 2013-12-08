  #
class amplet::server (
  $package_ensure   = $amplet::server::params::package_ensure,
  $package_provider = $amplet::server::params::package_provider,
  $cacert           = $amplet::server::params::cacert,
  $cert             = $amplet::server::params::cert,
  $key              = $amplet::server::params::key,
) inherits amplet::server::params {

  validate_string($package_ensure)
  validate_string($package_provider)
  validate_string($cacert)
  validate_string($cert)
  validate_string($key)

  include '::amplet::server::install'
  include '::amplet::server::config'

  case $::osfamily {
    'Debian':
      { include '::amplet::repo::apt' }
    default:
      { }
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'amplet::server::begin': }
  anchor { 'amplet::server::end': }

  Anchor['amplet::server::begin'] -> Class['::amplet::server::install']
    -> Class['::amplet::server::config']
    -> Anchor['amplet::server::end']

}
