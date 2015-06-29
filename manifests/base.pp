# configure couchdb
class couchdb::base {

  if $::couchdb::bigcouch == true {
    $couchdb_user = 'bigcouch'
    include couchdb::bigcouch
  } else {
    $couchdb_user = 'couchdb'
  }

  package { 'couchdb':
    ensure  => present,
    require => Exec['refresh_apt']
  }

  service { 'couchdb':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['couchdb']
  }

  # todo: make host/port configurable
  exec { 'wait_for_couchdb':
    command => 'wget --retry-connrefused --tries 10 --quiet "http://127.0.0.1:5984" -O /dev/null',
    require => Service['couchdb']
  }

  # required for couch-doc-update script
  package { 'couchrest':
    ensure   => installed,
    provider => 'gem'
  }

  File['/usr/local/bin/couch-doc-update'] ->  Couchdb::Update <| |>
  File['/usr/local/bin/couch-doc-diff'] ->  Couchdb::Update <| |>

  Couchdb::Update <| |> -> Couchdb::Document <| |>

  file {
    '/usr/local/bin/couch-doc-update':
      source  => 'puppet:///modules/couchdb/couch-doc-update',
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      require => Package['couchrest'];

    '/usr/local/bin/couch-doc-diff':
      source  => 'puppet:///modules/couchdb/couch-doc-diff',
      mode    => '0755',
      owner   => 'root',
      group   => 'root',
      require => Package['couchrest'];

    '/etc/couchdb/local.ini':
      source  => [ "puppet:///modules/site_couchdb/${::fqdn}/local.ini",
                  'puppet:///modules/site_couchdb/local.ini',
                  'puppet:///modules/couchdb/local.ini' ],
      notify  => Service[couchdb],
      owner   => $couchdb_user,
      group   => $couchdb_user,
      mode    => '0660',
      require => Package['couchdb'];

    '/etc/couchdb/local.d':
      ensure  => directory,
      require => Package['couchdb'];
  }

  $alg  = $::couchdb::pwhash_alg
  $salt = $::couchdb::admin_salt
  case $alg {
    'sha1': {
      # str_and_salt2sha1 is a function from leap's stdlib module
      $pw_and_salt = [ $::couchdb::admin_pw, $salt ]
      $sha1        = str_and_salt2sha1($pw_and_salt)
      $admin_hash  = "-hashed-${sha1},${salt}"
    }
    'pbkdf2': {
      $pbkdf2      = pbkdf2($::couchdb::admin_pw, $::couchdb::admin_salt, 10)
      $sha1        = $pbkdf2['sha1']
      $admin_hash  = "-pbkdf2-${sha1},${salt},10"
    }
    default:  { fail ("Unknown fact couchdb_pwhash_alg ${::couchdb_pwhash_alg} - Exiting.") }
  }

  file { '/etc/couchdb/local.d/admin.ini':
    content => "[admins]\nadmin = ${admin_hash}\n",
    mode    => '0600',
    owner   => $couchdb_user,
    group   => $couchdb_user,
    notify  => Service[couchdb],
    require => File ['/etc/couchdb/local.d'];
  }

  case $::couchdb::bigcouch {
    true: { $restart_command = '/etc/init.d/bigcouch restart; sleep 6' }
    default: { $restart_command = '/etc/init.d/couchdb restart; sleep 6' }
  }

  exec { 'couchdb_restart':
    command     => $restart_command,
    path        => ['/bin', '/usr/bin',],
    subscribe   => File['/etc/couchdb/local.d/admin.ini',
                        '/etc/couchdb/local.ini'],
    refreshonly => true
  }
}
