# == Class: zabbix
#
#  This will install and configure the zabbix-server on a single host.
#
#  Before release 1.0.0, there was one single class that was used for
#  installing zabbix-server components. So, this zabbix-server class
#  could only be used when you have only 1 server. When you want to use
#  multiple servers, than you had an problem (Or you just couldn't use
#  this puppet module).
#
#  With release 1.0.0, this zabbix-server class is split in 3 classes:
#    - zabbix::web
#    - zabbix::server
#    - zabbix::database
#
#  As not everyone is using an multiple host setup, this init.pp is created.
#  Besides some renaming of some parameters, this class can be used like
#  how the zabbix::server was used before release 1.0.0. Instead of using
#  class { 'zabbix::server':
#    zabbix_url => 'zabbix.dj-wasabi.nl',
#  }
#  you can now use:
#  class { 'zabbix':
#    zabbix_url => 'zabbix.dj-wasabi.nl',
#  }
#
# === Requirements
#
# === Parameters
#
#   All of the parameters which can be used in this script can be found in
#   one of the following classes:
#    - zabbix::web
#    - zabbix::server
#    - zabbix::database
#
#   When you want to run an multiple host setup, please check the classes
#   which are mentioned above. This class is single node only.
#
# === Example
#
#  When running everything on a single host, you can use the following
#  setup:
#
#  class { 'zabbix':
#    zabbix_url => 'zabbix.dj-wasabi.nl',
#  }
#
#  This assumes that you want to use the postgresql database. If not and
#  you want to supply your own database crendentials:
#
#  class { 'zabbix':
#    zabbix_url        => 'zabbix.dj-wasabi.nl',
#    database_type     => 'mysql',
#    database_user     => 'zabbix',
#    database_password => 'ThisIsVeryDifficult.nl',
#  }
#
#  When you want to run this module on multiple hosts, you'll have to check
#  the following classes (They have their own documentation):
#    - zabbix::web
#    - zabbix::server
#    - zabbix::database
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix (
  $zabbix_url                               = '',
  $zabbix_version                           = $zabbix::params::zabbix_version,
  $zabbix_timezone                          = $zabbix::params::zabbix_timezone,
  $zabbix_web                               = $zabbix::params::zabbix_web,
  $zabbix_server                            = $zabbix::params::zabbix_server,
  $zabbix_server_ip                         = $zabbix::params::zabbix_server_ip,
  $zabbix_template_dir                      = $zabbix::params::zabbix_template_dir,
  $zabbix_web_ip                            = $zabbix::params::zabbix_web_ip,
  $database_type                            = $zabbix::params::database_type,
  $database_path                            = $zabbix::params::database_path,
  $manage_database                          = $zabbix::params::manage_database,
  $manage_vhost                             = $zabbix::params::manage_vhost,
  $manage_firewall                          = $zabbix::params::manage_firewall,
  $manage_repo                              = $zabbix::params::manage_repo,
  $manage_resources                         = $zabbix::params::manage_resources,
  $apache_use_ssl                           = $zabbix::params::apache_use_ssl,
  $apache_ssl_cert                          = $zabbix::params::apache_ssl_cert,
  $apache_ssl_key                           = $zabbix::params::apache_ssl_key,
  $apache_ssl_cipher                        = $zabbix::params::apache_ssl_cipher,
  $apache_ssl_chain                         = $zabbix::params::apache_ssl_chain,
  $apache_listen_ip                         = $zabbix::params::apache_listen_ip,
  $apache_listenport                        = $zabbix::params::apache_listenport,
  $apache_listenport_ssl                    = $zabbix::params::apache_listenport_ssl,
  $apache_php_max_execution_time            = $zabbix::params::apache_php_max_execution_time,
  $apache_php_memory_limit                  = $zabbix::params::apache_php_memory_limit,
  $apache_php_post_max_size                 = $zabbix::params::apache_php_post_max_size,
  $apache_php_upload_max_filesize           = $zabbix::params::apache_php_upload_max_filesize,
  $apache_php_max_input_time                = $zabbix::params::apache_php_max_input_time,
  $apache_php_always_populate_raw_post_data = $zabbix::params::apache_php_always_populate_raw_post_data,
  $zabbix_api_user                          = $zabbix::params::server_api_user,
  $zabbix_api_pass                          = $zabbix::params::server_api_pass,
  $nodeid                                   = $zabbix::params::server_nodeid,
  $listenport                               = $zabbix::params::server_listenport,
  $sourceip                                 = $zabbix::params::server_sourceip,
  $logfile                                  = $zabbix::params::server_logfile,
  $logfilesize                              = $zabbix::params::server_logfilesize,
  $debuglevel                               = $zabbix::params::server_debuglevel,
  $pidfile                                  = $zabbix::params::server_pidfile,
  $database_host                            = $zabbix::params::server_database_host,
  $database_name                            = $zabbix::params::server_database_name,
  $database_schema                          = $zabbix::params::server_database_schema,
  $database_user                            = $zabbix::params::server_database_user,
  $database_password                        = $zabbix::params::server_database_password,
  $database_socket                          = $zabbix::params::server_database_socket,
  $database_port                            = $zabbix::params::server_database_port,
  $database_charset                         = $zabbix::params::server_database_charset,
  $database_collate                         = $zabbix::params::server_database_collate,
  $startpollers                             = $zabbix::params::server_startpollers,
  $startipmipollers                         = $zabbix::params::server_startipmipollers,
  $startpollersunreachable                  = $zabbix::params::server_startpollersunreachable,
  $starttrappers                            = $zabbix::params::server_starttrappers,
  $startpingers                             = $zabbix::params::server_startpingers,
  $startdiscoverers                         = $zabbix::params::server_startdiscoverers,
  $starthttppollers                         = $zabbix::params::server_starthttppollers,
  $starttimers                              = $zabbix::params::server_starttimers,
  $javagateway                              = $zabbix::params::server_javagateway,
  $javagatewayport                          = $zabbix::params::server_javagatewayport,
  $startjavapollers                         = $zabbix::params::server_startjavapollers,
  $startvmwarecollectors                    = $zabbix::params::server_startvmwarecollectors,
  $vmwarefrequency                          = $zabbix::params::server_vmwarefrequency,
  $vmwarecachesize                          = $zabbix::params::server_vmwarecachesize,
  $snmptrapperfile                          = $zabbix::params::server_snmptrapperfile,
  $startsnmptrapper                         = $zabbix::params::server_startsnmptrapper,
  $listenip                                 = $zabbix::params::server_listenip,
  $housekeepingfrequency                    = $zabbix::params::server_housekeepingfrequency,
  $maxhousekeeperdelete                     = $zabbix::params::server_maxhousekeeperdelete,
  $senderfrequency                          = $zabbix::params::server_senderfrequency,
  $cachesize                                = $zabbix::params::server_cachesize,
  $cacheupdatefrequency                     = $zabbix::params::server_cacheupdatefrequency,
  $startdbsyncers                           = $zabbix::params::server_startdbsyncers,
  $historycachesize                         = $zabbix::params::server_historycachesize,
  $trendcachesize                           = $zabbix::params::server_trendcachesize,
  $historytextcachesize                     = $zabbix::params::server_historytextcachesize,
  $valuecachesize                           = $zabbix::params::server_valuecachesize,
  $nodenoevents                             = $zabbix::params::server_nodenoevents,
  $nodenohistory                            = $zabbix::params::server_nodenohistory,
  $timeout                                  = $zabbix::params::server_timeout,
  $trappertimeout                           = $zabbix::params::server_trappertimeout,
  $unreachableperiod                        = $zabbix::params::server_unreachableperiod,
  $unavailabledelay                         = $zabbix::params::server_unavailabledelay,
  $unreachabledelay                         = $zabbix::params::server_unreachabledelay,
  $alertscriptspath                         = $zabbix::params::server_alertscriptspath,
  $externalscripts                          = $zabbix::params::server_externalscripts,
  $fpinglocation                            = $zabbix::params::server_fpinglocation,
  $fping6location                           = $zabbix::params::server_fping6location,
  $sshkeylocation                           = $zabbix::params::server_sshkeylocation,
  $logslowqueries                           = $zabbix::params::server_logslowqueries,
  $tmpdir                                   = $zabbix::params::server_tmpdir,
  $startproxypollers                        = $zabbix::params::server_startproxypollers,
  $proxyconfigfrequency                     = $zabbix::params::server_proxyconfigfrequency,
  $proxydatafrequency                       = $zabbix::params::server_proxydatafrequency,
  $allowroot                                = $zabbix::params::server_allowroot,
  $include_dir                              = $zabbix::params::server_include,
  $loadmodulepath                           = $zabbix::params::server_loadmodulepath,
  $loadmodule                               = $zabbix::params::server_loadmodule,
  ) inherits zabbix::params {

  class { 'zabbix::web':
    zabbix_url                               => $zabbix_url,
    database_type                            => $database_type,
    manage_repo                              => $manage_repo,
    zabbix_version                           => $zabbix_version,
    zabbix_timezone                          => $zabbix_timezone,
    zabbix_template_dir                      => $zabbix_template_dir,
    manage_vhost                             => $manage_vhost,
    manage_resources                         => $manage_resources,
    apache_use_ssl                           => $apache_use_ssl,
    apache_ssl_cert                          => $apache_ssl_cert,
    apache_ssl_key                           => $apache_ssl_key,
    apache_ssl_cipher                        => $apache_ssl_cipher,
    apache_ssl_chain                         => $apache_ssl_chain,
    apache_listen_ip                         => $apache_listen_ip,
    apache_listenport                        => $apache_listenport,
    apache_listenport_ssl                    => $apache_listenport_ssl,
    zabbix_api_user                          => $zabbix_api_user,
    zabbix_api_pass                          => $zabbix_api_pass,
    database_host                            => $database_host,
    database_name                            => $database_name,
    database_schema                          => $database_schema,
    database_user                            => $database_user,
    database_password                        => $database_password,
    database_socket                          => $database_socket,
    database_port                            => $database_port,
    zabbix_server                            => $zabbix_server,
    zabbix_listenport                        => $listenport,
    apache_php_max_execution_time            => $apache_php_max_execution_time,
    apache_php_memory_limit                  => $apache_php_memory_limit,
    apache_php_post_max_size                 => $apache_php_post_max_size,
    apache_php_upload_max_filesize           => $apache_php_upload_max_filesize,
    apache_php_max_input_time                => $apache_php_max_input_time,
    apache_php_always_populate_raw_post_data => $apache_php_always_populate_raw_post_data,
    require                                  => Class['zabbix::server'],
  }

  class { 'zabbix::server':
    database_type           => $database_type,
    database_path           => $database_path,
    zabbix_version          => $zabbix_version,
    manage_firewall         => $manage_firewall,
    manage_repo             => $manage_repo,
    nodeid                  => $nodeid,
    listenport              => $listenport,
    sourceip                => $sourceip,
    logfile                 => $logfile,
    logfilesize             => $logfilesize,
    debuglevel              => $debuglevel,
    pidfile                 => $pidfile,
    database_host           => $database_host,
    database_name           => $database_name,
    database_schema         => $database_schema,
    database_user           => $database_user,
    database_password       => $database_password,
    database_socket         => $database_socket,
    database_port           => $database_port,
    startpollers            => $startpollers,
    startipmipollers        => $startipmipollers,
    startpollersunreachable => $startpollersunreachable,
    starttrappers           => $starttrappers,
    startpingers            => $startpingers,
    startdiscoverers        => $startdiscoverers,
    starthttppollers        => $starthttppollers,
    starttimers             => $starttimers,
    javagateway             => $javagateway,
    javagatewayport         => $javagatewayport,
    startjavapollers        => $startjavapollers,
    startvmwarecollectors   => $startvmwarecollectors,
    vmwarefrequency         => $vmwarefrequency,
    vmwarecachesize         => $vmwarecachesize,
    snmptrapperfile         => $snmptrapperfile,
    startsnmptrapper        => $startsnmptrapper,
    listenip                => $listenip,
    housekeepingfrequency   => $housekeepingfrequency,
    maxhousekeeperdelete    => $maxhousekeeperdelete,
    senderfrequency         => $senderfrequency,
    cachesize               => $cachesize,
    cacheupdatefrequency    => $cacheupdatefrequency,
    startdbsyncers          => $startdbsyncers,
    historycachesize        => $historycachesize,
    trendcachesize          => $trendcachesize,
    historytextcachesize    => $historytextcachesize,
    valuecachesize          => $valuecachesize,
    nodenoevents            => $nodenoevents,
    nodenohistory           => $nodenohistory,
    timeout                 => $timeout,
    trappertimeout          => $trappertimeout,
    unreachableperiod       => $unreachableperiod,
    unavailabledelay        => $unavailabledelay,
    unreachabledelay        => $unreachabledelay,
    alertscriptspath        => $alertscriptspath,
    externalscripts         => $externalscripts,
    fpinglocation           => $fpinglocation,
    fping6location          => $fping6location,
    sshkeylocation          => $sshkeylocation,
    logslowqueries          => $logslowqueries,
    tmpdir                  => $tmpdir,
    startproxypollers       => $startproxypollers,
    proxyconfigfrequency    => $proxyconfigfrequency,
    proxydatafrequency      => $proxydatafrequency,
    allowroot               => $allowroot,
    include_dir             => $include_dir,
    loadmodulepath          => $loadmodulepath,
    loadmodule              => $loadmodule,
    require                 => Class['zabbix::database'],
  }

  class { 'zabbix::database':
    zabbix_type       => 'server',
    zabbix_web        => $zabbix_web,
    zabbix_server     => $zabbix_server,
    zabbix_web_ip     => $zabbix_web_ip,
    zabbix_server_ip  => $zabbix_server_ip,
    manage_database   => $manage_database,
    database_type     => $database_type,
    database_name     => $database_name,
    database_user     => $database_user,
    database_password => $database_password,
    database_host     => $database_host,
    database_charset  => $database_charset,
    database_collate  => $database_collate,
    require           => Class['zabbix::repo'],
  }

}
