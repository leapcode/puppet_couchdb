class couchdb::bigcouch::package::cloudant {


  # cloudants signing key can be fetched from
  # http://packages.cloudant.com/KEYS, please use the apt module to
  # distribute it on your servers
  # It's verified fingerprint is:
  # BAF9 B315 D438 5FB9 B5DE 334B 59E0 1FBD 15BE 8E26

  apt::sources_list {'bigcouch-cloudant.list':
    content => 'deb http://packages.cloudant.com/debian squeeze main'
  }

  # right now, cloudant only provides authenticated ibigcouch 0.4.2 packages
  # for squeeze, therefore we need to include squeeze repo for depending 
  # packages
  if $::lsbdistcodename == 'wheezy' {
    apt::sources_list {'squeeze.list':
      content => 'deb http://http.debian.net/debian squeeze main
deb http://security.debian.org/ squeeze/updates main
',
      before  => Exec[refresh_apt]
    }
  }

}
