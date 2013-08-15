define couchdb::bigcouch::query (
  $cmd, $path, $host='127.0.0.1:5986', $data = '{}' ) {

  couchdb::query { "${name}":
    cmd  => $cmd,
    host => $host,
    path  => $path,
    data => $data
  }
}
