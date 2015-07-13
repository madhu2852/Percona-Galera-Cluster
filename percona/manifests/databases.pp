class percona::databases {


class { "::keystone::db::mysql":
    user          => $user,
    password      => hiera('mysql_root_password'),
    dbname        => "keystone",
    allowed_hosts => $::openstack::config::mysql_allowed_hosts,
    mysql_module  => '2.2',
 }

}
