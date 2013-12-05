# Class: amplet::client::service
#
#   This class manages the rabbitmq server service itself.
class amplet::client::service(
) inherits amplet::client {

  service { 'amplet2-client':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    name       => 'amplet2-client',
  }

}
