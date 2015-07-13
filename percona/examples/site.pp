node 'default' {

include stdlib
include apt
include percona::install

}

##### Give the FQDN of the server which you want to execute bootstarp command below	#####

if $fqdn == '' {
	include percona::bootstrap
}

