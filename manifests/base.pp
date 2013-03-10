class couchdb::base {

  if $::couchdb::bigcouch == true {
    $couchdb_user = 'bigcouch'
    include couchdb::bigcouch
  } else {
    $couchdb_user = 'couchdb'
  }


  package {'couchdb':
    ensure => present,
  }

  service {'couchdb':
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package['couchdb'],
  }

  # required for couch-doc-update script
  package { 'couchrest':
    ensure   => installed,
    provider => 'gem'
  }

  File['/usr/local/bin/couch-doc-update'] ->  Couchdb::Update <| |>

  file {
    '/usr/local/bin/couch-doc-update':
      source  => 'puppet:///modules/couchdb/couch-doc-update',
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

  # salt and encrypt admin pw
  $sha1_and_salt = str2sha1_and_salt($::couchdb::admin_pw)
  $sha1          = $sha1_and_salt[0]
  $salt          = $sha1_and_salt[1]

  file {'/etc/couchdb/local.d/admin.ini':
    content => "[admins]
admin = -hashed-${sha1},${salt}
",
    mode    => '0600',
    owner   => $couchdb_user,
    group   => $couchdb_user,
    notify  => Service[couchdb],
    require => File ['/etc/couchdb/local.d'];
  }

  exec { 'couchdb_restart':
    command     => $::couchdb::bigcouch ? {
      true    => '/etc/init.d/bigcouch restart; sleep 6',
      default => '/etc/init.d/couchdb  restart; sleep 6',
    },
    path        => ['/bin', '/usr/bin',],
    subscribe   => File['/etc/couchdb/local.d/admin.ini',
      '/etc/couchdb/local.ini'],
    refreshonly => true
  }


}
