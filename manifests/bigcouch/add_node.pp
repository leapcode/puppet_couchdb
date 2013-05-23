define couchdb::bigcouch::add_node {

  couchdb::bigcouch::query { "add_${name}":
    cmd  => 'PUT',
    url  => "nodes/bigcouch@${name}"
  }
}
