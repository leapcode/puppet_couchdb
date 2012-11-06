define couchdb::query ($host='127.0.0.1:5984', $cmd, $url, $data = '') { 
  exec { "/usr/bin/curl --netrc-file /etc/couchdb/couchdb.netrc -X $cmd $host/$url --data \'$data\'": }
}
