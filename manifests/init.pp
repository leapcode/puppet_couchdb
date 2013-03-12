class couchdb (
  $admin_pw,
  $bigcouch = false,
  $bigcouch_cookie = '' ) {
  case $::operatingsystem {
    Debian: {
      case $::lsbdistcodename {
        /lenny|squeeze|wheezy/: {
          include couchdb::debian
          if $bigcouch == true {
            include couchdb::bigcouch::debian
          }
        }
        default:         { fail "couchdb not available for ${::operatingsystem}/${::lsbdistcodename}" }
      }
    }
    RedHat: { include couchdb::redhat }
  }

  package { 'curl':
    ensure => installed,
  }
}
