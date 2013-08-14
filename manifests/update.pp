define couchdb::update ($db, $id, $data, $port='5984', $unless='/bin/false') {

  exec { "couch-doc-update --port ${port} --db ${db} --id ${id} --data \'${data}\'":
    require => Exec['wait_for_couchdb'],
    unless  => $unless
  }
}
