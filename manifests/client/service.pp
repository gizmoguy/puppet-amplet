class amplet::client::service {

  service { 'amplet2-client':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    name       => 'amplet2-client',
    require    => Service['rabbitmq-server']
  }

}
