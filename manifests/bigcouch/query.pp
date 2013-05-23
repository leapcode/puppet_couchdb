define couchdb::bigcouch::query (
  $cmd, $url, $host='127.0.0.1:5986', $data = '{}' ) {

  couchdb::query { "${name}":
    cmd  => $cmd,
    host => $host,
    url  => $url,
    data => $data
  }
}
