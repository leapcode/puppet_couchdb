define couchdb::create_db ( $host='127.0.0.1:5984',
                            $admins="{\"names\": [], \"roles\": [] }",
                            $readers="{\"names\": [], \"roles\": [] }") {

  Couchdb::Query["create_db_$name"] -> Couchdb::Query["db_security_${name}"]

  couchdb::query { "create_db_$name":
    cmd  => 'PUT',
    host => $host,
    url  => $name,
  }

  couchdb::query { "db_security_${name}":
    cmd  => 'PUT',
    host => $host,
    url  => "$name/_security",
    data => "{ \"admins\": $admins, \"readers\": $readers }"
  }

  #couchdb::update { "create_db_$name":
  #  db    => $name,
  #  id    => '',
  #  data  => ''
  #}

  #couchdb::update { "db_security_$name":
  #  db    => $name,
  #  id    => '_security',
  #  data => "{ \"admins\": $admins, \"readers\": $readers }"
  #}


}
