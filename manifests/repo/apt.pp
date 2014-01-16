# requires
#   puppetlabs-apt
class amplet::repo::apt {

  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-client' |>
  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-server' |>

  apt::source { 'amplet-repo':
    location    => 'http://amp.wand.net.nz/debian/',
    release     => $::lsbdistcodename,
    repos       => 'main',
    include_src => false,
    key         => '77002036',
    key_content => template('amplet/repo.pub.key.erb'),
  }
}
