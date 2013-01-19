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

}
