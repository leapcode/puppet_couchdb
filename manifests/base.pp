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

  # required for new passwords hashing in admin.ini
  package { 'pbkdf2':
    ensure   => installed,
    provider => 'gem'
  }

  Package['pbkdf2'] -> File['/etc/couchdb/local.d/admin.ini']

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

  if $::couchdb::admin_salt == '' {
    # unhashed, plaintext pw, no salt. For couchdb >= 1.2
    $sha1_and_salt = str2sha1_and_salt($::couchdb::admin_pw)
    $sha1          = $sha1_and_salt[0]
    $salt          = $sha1_and_salt[1]
  } else {
    # prehashed pw with salt, for couchdb < 1.2
    # salt and encrypt pw
    # str_and_salt2sha1 is a function from leap's stdlib module
    $salt        = $::couchdb::admin_salt
    $pw_and_salt = [ $::couchdb::admin_pw, $salt ]
    $sha1        = str_and_salt2sha1($pw_and_salt)
    $pbkdf2      = str_and_salt2pbkdf2($pw_and_salt)
  }

  file { '/etc/couchdb/local.d/admin.ini':
    content => "[admins]
admin = -pbkdf2-${pbkdf2[0]},${pbkdf2[1]},${pbkdf2[2]}
",
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
