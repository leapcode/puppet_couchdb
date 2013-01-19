define couchdb::add_user ( $roles, $pw, $host='127.0.0.1:5984' ) {
  couchdb::update { "update_user_$name":
    db    => '_users',
    id    => "org.couchdb.user:$name",
    data  => "{\"type\": \"user\", \"name\": \"$name\", \"roles\": $roles, \"password\": \"$pw\"}",
  }
}
