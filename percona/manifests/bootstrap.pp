class percona::bootstrap {

exec {"Boot starpping the cluster":
	command => "/etc/init.d/mysql bootstrap-pxc ",
	logoutput => true,
	require  => Class['mysql::server'],

}

}
