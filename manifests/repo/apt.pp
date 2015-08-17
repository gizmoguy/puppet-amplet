# requires
#   puppetlabs-apt
class amplet::repo::apt (
  $repo    = 'http://amp.wand.net.nz/debian/',
  $release = $::lsbdistcodename,
) {

  validate_string($repo)

  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-client' |>
  Class['amplet::repo::apt'] -> Package<| title == 'amplet2-server' |>

  apt::source { 'amplet-repo':
    location    => $repo,
    release     => $release,
    repos       => 'main',
    include_src => false,
    key         => 'A9765B25FA4AA5AA1D6D421C86CE832077002036',
    key_content => template('amplet/repo.pub.key.erb'),
  }
}
