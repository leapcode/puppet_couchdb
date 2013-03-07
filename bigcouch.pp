class couchdb::bigcouch {
  package { 'bigcouch':
    ensure => installed,
  }
  file { '/opt/bigcouch/etc/vm.args':
    source  => template('couchdb/bigcouch/vm.args'),
    mode    => '0644',
    owner   => 'bigcouch',
    group   => 'bigcouch',
    require => Package['bigcouch']
  }
}
