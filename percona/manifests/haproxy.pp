class percona::haproxy {
	
	package {'haproxy':
		ensure => latest,
}

	file {'/etc/haproxy/haproxy.cfg':
		ensure => present,
		content => template('/etc/puppet/modules/percona/templates/haproxy.cnf.erb'),	
		require => Package ['haproxy'],
}
}
