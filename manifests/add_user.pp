define couchdb::add_user ($host='127.0.0.1:5984', $roles, $pw ) {
  couchdb::query { "create_user_$name":
    cmd  => 'PUT',
    host => $host,
    url  => "_users/org.couchdb.user:$name",
    data => "{ \"_id\": \"org.couchdb.user:$name\", \"type\": \"user\", \"name\": \"$name\", \"roles\": $roles, \"password\": \"$pw\"}",
  }
}

