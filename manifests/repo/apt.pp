# requires
#   puppetlabs-apt
class amplet::repo::apt (
  $repo = 'http://amp.wand.net.nz/debian/',
) {

  validate_string($repo)

  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-client' |>
  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-server' |>

  apt::source { 'amplet-repo':
    location    => $repo,
    release     => $::lsbdistcodename,
    repos       => 'main',
    include_src => false,
    key         => '77002036',
    key_content => template('amplet/repo.pub.key.erb'),
  }
}
