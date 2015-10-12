class couchdb (
  $admin_pw,
  $admin_salt = '',
  $bigcouch = false,
  $bigcouch_cookie = '',
  $ednp_port = '9001',
  $chttpd_bind_address = '0.0.0.0',
  $pwhash_alg = 'sha1' )
{

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
