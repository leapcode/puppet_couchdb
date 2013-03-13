class couchdb::bigcouch::package::cloudant {

  # cloudant only provides unauthenticated packages
  # use this if you need bigcouch 0.4.0

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

}
