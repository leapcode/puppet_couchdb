define couchdb::query ($host, $cmd, $url, $data = '') { 
  exec { "/usr/bin/curl -X $cmd $host/$url --data \'$data\'": }
}
