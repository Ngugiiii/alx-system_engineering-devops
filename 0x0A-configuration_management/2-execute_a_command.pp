# kill_process.pp

exec { 'killmenow':
  command     => 'pkill killmenow',
  path        => ['/bin', '/usr/bin', '/usr/sbin'],
  refreshonly => true,
}

