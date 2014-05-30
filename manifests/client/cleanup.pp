class amplet::client::cleanup {

  file { '/etc/amplet2/client.conf':
    ensure  => absent,
    path    => '/etc/amplet2/client.conf',
  }

  file { '/etc/amplet2/nametable':
    ensure  => absent,
    path    => '/etc/amplet2/nametable',
  }

  file { '/etc/amplet2/schedule.d/schedule':
    ensure  => absent,
    path    => '/etc/amplet2/schedule.d/schedule',
  }

  file { '/etc/amplet2/schedule.d':
    ensure  => absent,
    path    => '/etc/amplet2/schedule.d',
  }

  file { '/etc/amplet2/keys/cacert.pem':
    ensure  => absent,
    path    => '/etc/amplet2/keys/cacert.pem',
  }

  file { '/etc/amplet2/keys/cert.pem':
    ensure  => absent,
    path    => '/etc/amplet2/keys/cert.pem',
  }

  file { '/etc/amplet2/keys/key.pem':
    ensure  => absent,
    path    => '/etc/amplet2/keys/key.pem',
  }

}
