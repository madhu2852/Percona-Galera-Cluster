class percona::grants {

grants => {
  'keystone@localhost/keystone.*' => {
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    table      => 'keystone.*',
    user       => 'keystone@localhost',
    require    => Class['percona::databases'],	 
 },
}

}
