class percona::install {

# apt repository

apt::source { "galera_percona_repo":
    location          => "http://repo.percona.com/apt/",
    release           => "squeeze",
    repos             => "percona",
  #  key               => "CD2EFD2A",
    include_src       => false,
}

$galera_nextserver = {
    "galera1.lan" => hiera('percona1_ip_address'),  # replace the empty string by $ipaddress_galera3 when all nodes are correclty setup
    "galera2.lan" => hiera('percona2_ip_address'),
    "galera2.lan" => hiera('percona3_ip_address'),
}

$galera_master = "galera1.lan"

class { 'mysql::server':
	  package_name => "percona-xtradb-cluster-server-5.5",
          root_password           => hiera('mysql_root_password'),
      	  #require => Apt::Source["galera_percona_repo"]
}

package{["xinetd",
        "percona-xtradb-cluster-galera-2.x",
        "percona-xtradb-cluster-client-5.5",
        "percona-xtrabackup"] :
  ensure => latest,
  require => Apt::Source["galera_percona_repo"]
}


#if $fqdn == $galera_master {

   #  database_user { "root@localhost":
    #  ensure => "present",
    #  password_hash => mysql_password("madhukarneel"), # can not change password in clustercheck script
    #  provider      => 'mysql',
    #  require => File["/root/.my.cnf"] # why this is require ?
   # }

    #database_user { "keystone1@localhost":
     # ensure => "present",
     # password_hash => mysql_password("hiera('mysql_root_password')"),
     # provider  => "mysql",
     # require => File["/root/.my.cnf"] # why this is require ?
   # }
#}

# set the same debian_sys_maint password

#exec{"set-mysql-debian-sys-miant-pass":
 
 #  command => "/bin/sed -i 's/^password.*/password = debiansysmaint_password!/g' /etc/mysql/debian.cnf",
  #  unless => "/bin/grep -qFx 'password = debiansysmaint_password!' /etc/mysql/debian.cnf",
   # require => Package["mysql-server"]
#}

service{"xinetd": hasstatus => false }

exec{"add-mysqlchk-in-etc-services":
    command => "/bin/echo mysqlchk 9200/tcp >> /etc/services",
    unless => "/bin/grep -qFx 'mysqlchk 9200/tcp' /etc/services",
    notify => Service["xinetd"],
}

# fix the broken link provided by the percona package

file{"/usr/local/bin/clustercheck":
    ensure => "link",
    target => "/usr/bin/clustercheck",
}

if $fqdn == hiera('boot_strappingnode_hostname') {

	include percona::replace
        include percona::bootstrap
	include percona::databases

	
	exec {'mysql_restart':
		command => "/etc/init.d/mysql restart",
		logoutput => true,
		require => Class['percona::bootstrap']
}

#	package {'python-mysqldb':
#		ensure => latest,
#		require => Class ['percona::bootstrap'],
#}


}		

else {
		 exec {'mysql_restart_nodes':
                command => "/etc/init.d/mysql restart",
                logoutput => true,
		require => Class['mysql::server::config'],		
	}
}



}



