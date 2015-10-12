# Couchdb Puppet module

This module is based on the one from Camptocamp_.

.. _Camptocamp: http://www.camptocamp.com/

For more information about couchdb see http://couchdb.apache.org/

# Dependencies

- ruby module from the shared-modules group

## Example usage

This will setup couchdb:

    # needed for wget call, which is unqualified by purpose so we don't force
    # a location for the wget binary
    Exec { path    => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin' }

    class { 'couchdb':
      admin_pw => '123'
    }

