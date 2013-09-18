# Usage:
# couchdb::document { id:
#   db => "database",
#   data => "content",
#   ensure => {absent,present,*content*}
# }
#
define couchdb::document(
  $db,
  $id,
  $host   = '127.0.0.1:5984',
  $data   = '{}',
  $ensure = 'content') {

  $url = "${host}/${db}/${id}"

  case $ensure {
    default: { err ( "unknown ensure value '${ensure}'" ) }
    content: {
      exec { "couch-doc-update --host ${host} --db ${db} --id ${id} --data \'${data}\'":
        require => Exec['wait_for_couchdb'],
        unless  => "couch-doc-diff $url '$data'"
      }
    }

    present: {
      couchdb::query { "create_${db}_${id}":
        cmd    => 'PUT',
        host   => $host,
        path   => "${db}/${id}",
        unless => "/usr/bin/curl -s -f --netrc-file /etc/couchdb/couchdb.netrc ${url}"
      }
    }

    absent: {
      couchdb::query { "destroy_${db}_${id}":
        cmd    => 'DELETE',
        host   => $host,
        path   => "${db}/${id}",
        unless => "/usr/bin/curl -s -f --netrc-file /etc/couchdb/couchdb.netrc ${url}"
      }
    }
  }
}
