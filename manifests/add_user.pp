define couchdb::add_user ( $roles, $pw ) {

  if $::couchdb::bigcouch == true {
    $port = 5986
  } else {
    $port = 5984
}

  couchdb::update { "update_user_$name":
    port => $port,
    db   => '_users',
    id   => "org.couchdb.user:$name",
    data => "{\"type\": \"user\", \"name\": \"$name\", \"roles\": $roles, \"password\": \"$pw\"}",
  }
}
