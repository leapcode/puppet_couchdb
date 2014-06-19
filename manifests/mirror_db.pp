define couchdb::mirror_db (
  $host='127.0.0.1:5984',
  $from='',
  $to='' )
{
  $source = "$from$name"
  $target = "$to$name"

  couchdb::document { "${name}_replication":
    db   => "_replicate",
    id   => "${name}_replication",
    host => $host,
    data   => "{ \"source\": ${source}, \"target\": ${target}, \"continuous\": true }",
    require => Couchdb::Query["create_db_${name}"]
  }
}
