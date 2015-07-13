class percona::replace {

file_line {'replace_file_in_master':
  ensure  => present,
  path    => '/etc/mysql/my.cnf',
  line    => "wsrep_cluster_address='gcomm://'",
  match   => 'wsrep_cluster_address=',
  }
 }
