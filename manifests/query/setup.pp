define couchdb::query::setup ($host='127.0.0.1', $user, $pw) {
  file { '/etc/couchdb/couchdb.netrc':
    content => "machine $host login $user password $pw",
    mode    => '0600',
    owner   => 'couchdb',
    group   => 'couchdb',
  }
}
