define couchdb::bigcouch::add_node {

  couchdb::bigcouch::query { "add_${name}":
    cmd  => 'PUT',
    path  => "nodes/bigcouch@${name}"
  }
}
