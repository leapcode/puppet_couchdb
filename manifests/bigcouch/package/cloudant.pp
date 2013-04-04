class couchdb::bigcouch::package::cloudant {

  # cloudant's signing key can be fetched from
  # http://packages.cloudant.com/KEYS, please use the apt module to
  # distribute it on your servers after verifying its fingerprint

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
    }
  }

}
