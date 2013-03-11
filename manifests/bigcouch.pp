class couchdb::bigcouch inherits couchdb::base {

  apt::sources_list {'bigcouch-cloudant.list':
    content => "deb http://packages.cloudant.com/debian $::lsbdistcodename main"
  }

  # currently, there's no other way with puppet to install unauthenticated
  # pacakges: http://projects.puppetlabs.com/issues/556
  # so we need to globally allow apt to install unauthenticated
  # packages.

  apt::apt_conf { 'allow_unauthenticated':
    content => 'APT::Get::AllowUnauthenticated yes;',
  }

  file {'/etc/couchdb':
    ensure  => link,
    target  => '/opt/bigcouch/etc',
    require => Package['couchdb']
  }

  Package ['couchdb'] {
    name    => 'bigcouch',
    require => [ Apt::Sources_list ['bigcouch-cloudant.list'],
      Apt::Apt_conf ['allow_unauthenticated'], 
      Exec[refresh_apt] ]
  }

  file { '/opt/bigcouch/etc/vm.args':
    content => template('couchdb/bigcouch/vm.args'),
    mode    => '0640',
    owner   => 'bigcouch',
    group   => 'bigcouch',
    require => Package['couchdb']
  }

  Service ['couchdb'] {
    provider => 'runit',
    name     => 'bigcouch'
  }

}
