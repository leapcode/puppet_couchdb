define couchdb::add_user ($host, $roles, $pw ) {

  #exec { "/usr/bin/curl -X PUT $host/_users/org.couchdb.user:$name --data \'{ \"_id\": \"org.couchdb.user:$name\", \"type\": \"user\", \"name\": \"$name\", \"roles\": $roles, \"password\": \"$pw\"}\'":
  #  unless => "/usr/bin/curl -s -X GET $host/_users/org.couchdb.user:$name| grep -qv error",
  #}

  site_couchdb::query { "create_user_$name":
    cmd  => 'PUT',
    host => $host,
    url  => "_users/org.couchdb.user:$name",
    data => "{ \"_id\": \"org.couchdb.user:$name\", \"type\": \"user\", \"name\": \"$name\", \"roles\": $roles, \"password\": \"$pw\"}",
  }

}

