# == Class: squid
class squid ( 
  $http_port            = [ '3128' ] ,
  $package_name 	= 'squid',
  $service_name  	= 'squid',
  $config_file   	= '/etc/squid/squid.conf',
  $log_directory 	= '/var/log/squid',
  $coredump_dir  	= '/var/spool/squid',
  $access_log        	= [ "${log_directory}/access.log squid" ],
  $cache_log       	= "${log_directory}/cache.log",
  $cache_store_log 	= "${log_directory}/store.log"
)
{ 
  package { $package_name: 
    ensure => installed, 
    name => $package_name,
  }

  service { $service_name:
    enable    => true,
    name      => $service_name,
    ensure    => running,
    restart   => "systemctl restart ${service_name}",
    path      => ['/sbin', '/usr/sbin'],
    hasstatus => true,
    require   => Package[$package_name],
  }

  file { $config_file:
    require => Package[$package_name],
    notify  => Service[$service_name],
    content => template('squid/squid.conf.erb'),
  }
}
