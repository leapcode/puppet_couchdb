class couchdb::base {

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
  file { '/usr/local/bin/couch-doc-update':
    source  => 'puppet:///modules/couchdb/couch-doc-update',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package['couchrest'],
  }

}
