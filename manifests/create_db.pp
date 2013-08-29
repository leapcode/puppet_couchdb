define couchdb::create_db (
  $host='127.0.0.1:5984',
  $admins="{\"names\": [], \"roles\": [] }",
  $readers="{\"names\": [], \"roles\": [] }" )
{

  Couchdb::Query["create_db_${name}"] -> Couchdb::Query["db_security_${name}"]

  couchdb::query { "create_db_${name}":
    cmd    => 'PUT',
    host   => $host,
    url    => $name,
    unless => "/usr/bin/curl -s --netrc-file /etc/couchdb/couchdb.netrc ${host}/${name} | grep -q -v '{\"error\":\"not_found\"'"
  }

  couchdb::query { "db_security_${name}":
    cmd  => 'PUT',
    host => $host,
    url  => "${name}/_security",
    data => "{ \"admins\": ${admins}, \"readers\": ${readers} }"
  }
}
