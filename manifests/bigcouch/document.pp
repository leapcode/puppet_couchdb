define couchdb::bigcouch::document ( $host='127.0.0.1:5986', $db, $id, $data='{}', $ensure='content') {
  couchdb::document { "${name}":
    host => $host,
    db   => $db,
    id   => $id,
    data => $data,
    ensure => $ensure
  }
}
