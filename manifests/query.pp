define couchdb::query (
  $cmd, $path, $host='127.0.0.1:5984', $data = '{}', $unless = undef) {

  exec { "/usr/bin/curl -s --netrc-file /etc/couchdb/couchdb.netrc -X ${cmd} ${host}/${path} --data \'${data}\'":
    require => [ Package['curl'], Exec['wait_for_couchdb'] ],
    unless  => $unless
  }
}
