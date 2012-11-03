define couchdb::create_db ($host, 
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

}
