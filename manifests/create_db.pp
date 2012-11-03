define couchdb::create_db ($host, 
                                $admins="{\"names\": [], \"roles\": [] }", 
                                $readers="{\"names\": [], \"roles\": [] }") {

  Site_couchdb::Query["create_db_$name"] -> Site_couchdb::Query["db_security_${name}"]

  site_couchdb::query { "create_db_$name":
    cmd  => 'PUT',
    host => $host,
    url  => $name,
  }

  site_couchdb::query { "db_security_${name}":
    cmd  => 'PUT',
    host => $host,
    url  => "$name/_security",
    data => "{ \"admins\": $admins, \"readers\": $readers }"
  }

}
