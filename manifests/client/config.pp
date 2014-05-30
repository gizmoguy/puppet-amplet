class amplet::client::config {

  $ampname             = $amplet::client::ampname
  $ampcollector        = $amplet::client::ampcollector
  $service_config      = $amplet::client::service_config
  $service_config_path = $amplet::client::service_config_path
  $config              = $amplet::client::config
  $config_path         = $amplet::client::config_path
  $nametable_config    = $amplet::client::nametable_config
  $nametable_path      = $amplet::client::nametable_path
  $schedule_config     = $amplet::client::schedule_config
  $schedule_path       = $amplet::client::schedule_path
  $keys_path           = $amplet::client::keys_path

  file { '/etc/default/amplet2-client':
    ensure  => file,
    path    => $service_path,
    content => template($service_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { 'client.conf':
    ensure  => file,
    path    => $config_path,
    content => template($config),
    owner   => '0',
    group   => '0',
    mode    => '0644'
  }

  file { $nametable_path:
    ensure  => directory,
    path    => $nametable_path,
    owner   => '0',
    group   => '0',
    mode    => '0755'
  }

  file { 'puppet.name':
    ensure  => file,
    path    => "${nametable_path}/puppet.name",
    content => template($nametable_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { $schedule_path:
    ensure  => directory,
    path    => $schedule_path,
    owner   => '0',
    group   => '0',
    mode    => '0755'
  }

  file { 'puppet.sched':
    ensure  => file,
    path    => "${schedule_path}/puppet.sched",
    content => template($schedule_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { $keys_path:
    ensure  => directory,
    path    => $keys_path,
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0700'
  }

  file { 'cacert.pem':
    ensure  => file,
    path    => "${keys_path}/cacert.pem",
    content => template('amplet/client/cacert.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0644'
  }

  file { 'cert.pem':
    ensure  => file,
    path    => "${keys_path}/cert.pem",
    content => template('amplet/client/cert.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0644'
  }

  file { 'key.pem':
    ensure  => file,
    path    => "${keys_path}/key.pem",
    content => template('amplet/client/key.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0600'
  }

  exec { "/usr/sbin/amplet2 -f":
    command     => "/usr/sbin/amplet2 -f -c ${config_path}",
    cwd         => "/tmp",
    path        => ["/bin", "/usr/bin", "/usr/sbin"],
    environment => "HOME=/tmp",
    refreshonly => true,
    subscribe   => File['client.conf'],
    notify      => Class['amplet::client::service']
  }

}
