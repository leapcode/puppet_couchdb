define couchdb::update ($db, $id, $data) {
  exec { "couch-doc-update --db $db --id $id --data \'$data\'": }
}
