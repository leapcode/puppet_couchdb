class couchdb::debian inherits couchdb::base {

  package { 'libjs-jquery':
    ensure => present,
  }

  file { '/etc/init.d/couchdb':
    source  => [
      'puppet:///modules/site_couchdb/Debian/couchdb',
      'puppet:///modules/couchdb/Debian/couchdb' ],
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    require => Package['couchdb']
  }
}
