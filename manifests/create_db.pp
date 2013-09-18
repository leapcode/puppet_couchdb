define couchdb::create_db (
  $host='127.0.0.1:5984',
  $admins="{\"names\": [], \"roles\": [] }",
  $readers="{\"names\": [], \"roles\": [] }" )
{

  couchdb::query { "create_db_${name}":
    cmd    => 'PUT',
    host   => $host,
    path   => $name,
    unless => "/usr/bin/curl -s -f --netrc-file /etc/couchdb/couchdb.netrc ${host}/${name}"
  }

  couchdb::query { "${name}_security":
    cmd     => 'PUT',
    host    => $host,
    path    => "${name}/_security",
    data    => "{ \"admins\": ${admins}, \"readers\": ${readers} }",
    require => Couchdb::Query["create_db_${name}"]
  }
}
