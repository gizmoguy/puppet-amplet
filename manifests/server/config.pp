class amplet::server::config {

  file {'/etc/amplet2':
    ensure => directory,
    path   => '/etc/amplet2',
    owner  => '0',
    group  => '0',
    mode   => '0755'
  }

  file {'/etc/amplet2/keys':
    ensure => directory,
    path   => '/etc/amplet2/keys',
    owner  => 'rabbitmq',
    group  => '0',
    mode   => '0700'
  }

  file {'/etc/amplet2/keys/server':
    ensure => directory,
    path   => '/etc/amplet2/keys/server',
    owner  => 'rabbitmq',
    group  => '0',
    mode   => '0700'
  }

  file { 'cacert.pem':
    ensure  => file,
    path    => '/etc/amplet2/keys/server/cacert.pem',
    content => template('amplet/server/cacert.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0644'
  }

  file { 'cert.pem':
    ensure  => file,
    path    => '/etc/amplet2/keys/server/cert.pem',
    content => template('amplet/server/cert.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0644'
  }

  file { 'key.pem':
    ensure  => file,
    path    => '/etc/amplet2/keys/server/key.pem',
    content => template('amplet/server/key.pem.erb'),
    owner   => 'rabbitmq',
    group   => '0',
    mode    => '0600'
  }

}
