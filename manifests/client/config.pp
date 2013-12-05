class amplet::client::config {

  $service_config      = $amplet::client::service_config
  $service_config_path = $amplet::client::service_config_path
  $config              = $amplet::client::config
  $config_path         = $amplet::client::config_path
  $nametable_config    = $amplet::client::nametable_config
  $nametable_path      = $amplet::client::nametable_path
  $schedule_config     = $amplet::client::schedule_config
  $schedule_path       = $amplet::client::schedule_path

  file { '/etc/default/amplet2-client':
    ensure  => file,
    path    => $service_path,
    content => template($service_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { '/etc/amplet2/client.conf':
    ensure  => file,
    path    => $config_path,
    content => template($config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { '/etc/amplet2/nametable':
    ensure  => file,
    path    => $nametable_path,
    content => template($nametable_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

  file { '/etc/amplet2/schedule.d/schedule':
    ensure  => file,
    path    => $schedule_path,
    content => template($schedule_config),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Class['amplet::client::service'],
  }

}
