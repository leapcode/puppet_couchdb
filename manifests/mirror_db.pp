define couchdb::mirror_db (
  $host='127.0.0.1:5984',
  $from='',
  $to='' )
{
  $source = "$from/$name"
  if $to == '' { $target = $name }
  else { $target = "$to/$name" }

  $replication_user = "replication"
  $replication_role = "replication"

  couchdb::document { "${name}_replication":
    db   => "_replicator",
    id   => "${name}_replication",
    host => $host,
    data   => "{ \"source\": \"${source}\", \"target\": \"${target}\", \"continuous\": true, \"user_ctx\": { \"name\": \"${replication_user}\", \"roles\": [\"${replication_role}\"] } }",
    require => Couchdb::Query["create_db_${name}"]
  }
}
