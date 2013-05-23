define couchdb::query (
  $cmd, $url, $host='127.0.0.1:5984', $data = '{}' ) {

  exec { "/usr/bin/curl --netrc-file /etc/couchdb/couchdb.netrc -X ${cmd} ${host}/${url} --data \'${data}\'":
    require => [ Package['curl'], Exec['wait_for_couchdb'] ]
  }
}
