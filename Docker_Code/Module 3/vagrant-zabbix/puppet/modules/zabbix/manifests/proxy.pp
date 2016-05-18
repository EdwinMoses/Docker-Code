# == Class: zabbix::proxy
#
#  This will install and configure the zabbix-proxy deamon
#
# === Requirements
#
# When 'manage_database' is set to true, the corresponding database class
# in 'database_type' should be required.
#
# === Parameters
#
# [*database_type*]
#   Type of database. Can use the following 3 databases:
#   - postgresql
#   - mysql
#   - sqlite
#
# [*database_path*]
#  When database binaries are not found on the default path:
#  /bin:/usr/bin:/usr/local/sbin:/usr/local/bin
#  you can use this parameter to add the database_path to the above mentiond
#  path.
#
# [*zabbix_version*]
#   This is the zabbix version.
#
# [*zabbix_package_state*]
#   The state of the package that needs to be installed: present or latest.
#   Default: present
#
# [*manage_database*]
#   When true, it will configure the database and execute the sql scripts.
#
# [*manage_firewall*]
#   When true, it will create iptables rules.
#
# [*manage_repo*]
#   When true, it will create repository for installing the proxy.
#
# [*manage_resources*]
#   When true, it will export resources so that the zabbix-server can create
#   via the zabbix-api proxy.
#
# [*use_ip*]
#   When true, when creating proxies via the zabbix-api, it will configure that
#   connection should me made via ip, not fqdn.
#
# [*zbx_templates*]
#   Template which will be added when proxy is configured.
#
# [*proxy_configfile_path*]
#   Proxy config file path defaults to /etc/zabbix/zabbix_proxy.conf
#
# [*mode*]
#   Proxy operating mode.
#
# [*zabbix_server_host*]
#   Hostname or the ipaddress of the zabbix-server.
#
# [*zabbix_server_port*]
#   Port on which the server is listening.
#
# [*hostname*]
#  Hostname for the proxy. Default is $::fqdn or this parameter.
#
# [*listenport*]
#   Listen port for trapper.
#
# [*sourceip*]
#   Source ip address for outgoing connections.
#
# [*logfile*]
#   Name of log file.
#
# [*logfilesize*]
#   Maximum size of log file in MB.
#
# [*debuglevel*]
#   Specifies debug level.
#
# [*pidfile*]
#   Name of pid file.
#
# [*database_host*]
#   Database host name.
#
# [*database_name*]
#   Database name.
#
# [*database_schema*]
#   Schema name. used for ibm db2.
#
# [*database_user*]
#   Database user. ignored for sqlite.
#
# [*database_password*]
#   Database password. ignored for sqlite.
#
# [*database_socket*]
#   Path to mysql socket.
#
# [*database_port*]
#   Database port when not using local socket. Ignored for sqlite.
#
# [*localbuffer*]
#   Proxy will keep data locally for N hours, even if the data have already been synced with the server
#
# [*offlinebuffer*]
#   Proxy will keep data for N hours in case if no connectivity with Zabbix Server
#
# [*heartbeatfrequency*]
#   Unique nodeid in distributed setup.
#
# [*configfrequency*]
#   Unique nodeid in distributed setup.
#
# [*datasenderfrequency*]
#   Proxy will send collected data to the Server every N seconds.
#
# [*startpollers*]
#   Number of pre-forked instances of pollers.
#
# [*startipmipollers*]
#   Number of pre-forked instances of ipmi pollers.
#
# [*startpollersunreachable*]
#   Number of pre-forked instances of pollers for unreachable hosts (including ipmi).
#
# [*starttrappers*]
#   Number of pre-forked instances of trappers.
#
# [*startpingers*]
#   Number of pre-forked instances of icmp pingers.
#
# [*startdiscoverers*]
#   Number of pre-forked instances of discoverers.
#
# [*starthttppollers*]
#   Number of pre-forked instances of http pollers.
#
# [*javagateway_host*]
#   IP address (or hostname) of zabbix java gateway.
#
# [*javagateway_port*]
#   Port that zabbix java gateway listens on.
#
# [*startjavapollers*]
#   Number of pre-forked instances of java pollers.
#
# [*startvmwarecollectors*]
#   Number of pre-forked vmware collector instances.
#
# [*vmwarefrequency*]
#   How often zabbix will connect to vmware service to obtain a new datan.
#
# [*vmwarecachesize*]
#   Size of vmware cache, in bytes.
#
# [*snmptrapperfile*]
#   Temporary file used for passing data from snmp trap daemon to the server.
#
# [*startsnmptrapper*]
#   If 1, snmp trapper process is started.
#
# [*listenip*]
#   List of comma delimited ip addresses that the trapper should listen on.
#
# [*housekeepingfrequency*]
#   How often Zabbix will perform housekeeping procedure (in hours).
#
# [*cachesize*]
#   Size of configuration cache, in MB.
#
# [*startdbsyncers*]
#   Number of pre-forked instances of db syncers.
#
# [*historycachesize*]
#   Size of history cache, in bytes.
#
# [*historytextcachesize*]
#   Size of text history cache, in bytes.
#
# [*timeout*]
#   Specifies how long we wait for agent, snmp device or external check (in seconds).
#
# [*trappertimeout*]
#   Specifies how many seconds trapper may spend processing new data.
#
# [*unreachableperiod*]
#   After how many seconds of unreachability treat a host as unavailable.
#
# [*unavailabledelay*]
#   How often host is checked for availability during the unavailability period, in seconds.
#
# [*unreachabledelay*]
#   How often host is checked for availability during the unreachability period, in seconds.
#
# [*externalscripts*]
#   Full path to location of external scripts.
#
# [*fpinglocation*]
#   Location of fping.
#
# [*fping6location*]
#   Location of fping6.
#
# [*sshkeylocation*]
#   Location of public and private keys for ssh checks and actions.
#
# [*logslowqueries*]
#   How long a database query may take before being logged (in milliseconds).
#
# [*tmpdir*]
#   Temporary directory.
#
# [*allowroot*]
#   Allow the server to run as 'root'.
#
# [*include_dir*]
#   You may include individual files or all files in a directory in the configuration file.
#
# [*loadmodulepath*]
#   Full path to location of server modules.
#
# [*loadmodule*]
#   Module to load at server startup.
#
# === Example
#
#  When you want to run everything on one machine, you can use the following
#  example:
#  class { 'zabbix::proxy':
#    zabbix_server_host => '192.168.1.1',
#    zabbix_server_port => '10051',
#  }
#
#  When you want to use mysql:
#  class { 'zabbix::proxy':
#    zabbix_server_host => '192.168.1.1',
#    zabbix_server_port => '10051',
#    database_type      => 'mysql',
#  }
#
#  The zabbix::proxy can also be split like the server into 2 servers:
#  - zabbix::proxy
#  - zabbix::database
#
#  The following is an example of running the proxy on 2 servers:
#  node 'wdpuppet03.dj-wasabi.local' {
#    #class { 'postgresql::client': }
#    class { 'mysql::client': }
#    class { 'zabbix::proxy':
#      zabbix_server_host => '192.168.1.1',
#      manage_database    => false,
#      database_host      => 'wdpuppet04.dj-wasabi.local',
#      database_type      => 'mysql',
#    }
#  }
#
#  node 'wdpuppet04.dj-wasabi.local' {
#    #class { 'postgresql::server':
#    #    listen_addresses => '192.168.20.14'
#    #  }
#      class { 'mysql::server':
#        override_options => {
#          'mysqld'       => {
#            'bind_address' => '192.168.20.14',
#          },
#        },
#      }
#    class { 'zabbix::database':
#      database_type     => 'mysql',
#      zabbix_type       => 'proxy',
#      #zabbix_proxy_ip   => '192.168.20.13',
#      zabbix_proxy      => 'wdpuppet03.dj-wasabi.local',
#      database_name     => 'zabbix-proxy',
#      database_user     => 'zabbix-proxy',
#      database_password => 'zabbix-proxy',
#    }
#  }
#
#  The example of above is running the proxy with an mysql backend. When
#  you want to use postgresql, you'll need to uncomment the postgresql class
#  and the zabbix_proxy_ip and comment the mysql class, database_type and the
#  zabbix_proxy parameters.
#
# === Authors
#
# Author Name: ikben@werner-dijkerman.nl
#
# === Copyright
#
# Copyright 2014 Werner Dijkerman
#
class zabbix::proxy (
  $database_type           = $zabbix::params::database_type,
  $database_path           = $zabbix::params::database_path,
  $zabbix_version          = $zabbix::params::zabbix_version,
  $zabbix_package_state    = $zabbix::params::zabbix_package_state,
  $manage_database         = $zabbix::params::manage_database,
  $manage_firewall         = $zabbix::params::manage_firewall,
  $manage_repo             = $zabbix::params::manage_repo,
  $manage_resources        = $zabbix::params::manage_resources,
  $zabbix_proxy            = $zabbix::params::zabbix_proxy,
  $zabbix_proxy_ip         = $zabbix::params::zabbix_proxy_ip,
  $use_ip                  = $zabbix::params::proxy_use_ip,
  $zbx_templates           = $zabbix::params::proxy_zbx_templates,
  $proxy_configfile_path   = $zabbix::params::proxy_configfile_path,
  $proxy_service_name      = $zabbix::params::proxy_service_name,
  $mode                    = $zabbix::params::proxy_mode,
  $zabbix_server_host      = $zabbix::params::proxy_zabbix_server_host,
  $zabbix_server_port      = $zabbix::params::proxy_zabbix_server_port,
  $hostname                = $zabbix::params::proxy_hostname,
  $listenport              = $zabbix::params::proxy_listenport,
  $sourceip                = $zabbix::params::proxy_sourceip,
  $logfile                 = $zabbix::params::proxy_logfile,
  $logfilesize             = $zabbix::params::proxy_logfilesize,
  $debuglevel              = $zabbix::params::proxy_debuglevel,
  $pidfile                 = $zabbix::params::proxy_pidfile,
  $database_schema_path    = $zabbix::params::database_schema_path,
  $database_host           = $zabbix::params::proxy_database_host,
  $database_name           = $zabbix::params::proxy_database_name,
  $database_schema         = $zabbix::params::proxy_database_schema,
  $database_user           = $zabbix::params::proxy_database_user,
  $database_password       = $zabbix::params::proxy_database_password,
  $database_socket         = $zabbix::params::proxy_database_socket,
  $database_port           = $zabbix::params::proxy_database_port,
  $localbuffer             = $zabbix::params::proxy_localbuffer,
  $offlinebuffer           = $zabbix::params::proxy_offlinebuffer,
  $heartbeatfrequency      = $zabbix::params::proxy_heartbeatfrequency,
  $configfrequency         = $zabbix::params::proxy_configfrequency,
  $datasenderfrequency     = $zabbix::params::proxy_datasenderfrequency,
  $startpollers            = $zabbix::params::proxy_startpollers,
  $startipmipollers        = $zabbix::params::proxy_startipmipollers,
  $startpollersunreachable = $zabbix::params::proxy_startpollersunreachable,
  $starttrappers           = $zabbix::params::proxy_starttrappers,
  $startpingers            = $zabbix::params::proxy_startpingers,
  $startdiscoverers        = $zabbix::params::proxy_startdiscoverers,
  $starthttppollers        = $zabbix::params::proxy_starthttppollers,
  $javagateway             = $zabbix::params::proxy_javagateway,
  $javagatewayport         = $zabbix::params::proxy_javagatewayport,
  $startjavapollers        = $zabbix::params::proxy_startjavapollers,
  $startvmwarecollectors   = $zabbix::params::proxy_startvmwarecollectors,
  $vmwarefrequency         = $zabbix::params::proxy_vmwarefrequency,
  $vmwarecachesize         = $zabbix::params::proxy_vmwarecachesize,
  $snmptrapperfile         = $zabbix::params::proxy_snmptrapperfile,
  $snmptrapper             = $zabbix::params::proxy_snmptrapper,
  $listenip                = $zabbix::params::proxy_listenip,
  $housekeepingfrequency   = $zabbix::params::proxy_housekeepingfrequency,
  $cachesize               = $zabbix::params::proxy_cachesize,
  $startdbsyncers          = $zabbix::params::proxy_startdbsyncers,
  $historycachesize        = $zabbix::params::proxy_historycachesize,
  $historytextcachesize    = $zabbix::params::proxy_historytextcachesize,
  $timeout                 = $zabbix::params::proxy_timeout,
  $trappertimeout          = $zabbix::params::proxy_trappertimeout,
  $unreachableperiod       = $zabbix::params::proxy_unreachableperiod,
  $unavaliabledelay        = $zabbix::params::proxy_unavaliabledelay,
  $unreachabedelay         = $zabbix::params::proxy_unreachabedelay,
  $externalscripts         = $zabbix::params::proxy_externalscripts,
  $fpinglocation           = $zabbix::params::proxy_fpinglocation,
  $fping6location          = $zabbix::params::proxy_fping6location,
  $sshkeylocation          = $zabbix::params::proxy_sshkeylocationundef,
  $loglowqueries           = $zabbix::params::proxy_loglowqueries,
  $tmpdir                  = $zabbix::params::proxy_tmpdir,
  $allowroot               = $zabbix::params::proxy_allowroot,
  $include_dir             = $zabbix::params::proxy_include,
  $loadmodulepath          = $zabbix::params::proxy_loadmodulepath,
  $loadmodule              = $zabbix::params::proxy_loadmodule,
) inherits zabbix::params {

  # Check some if they are boolean
  validate_bool($manage_database)
  validate_bool($manage_firewall)
  validate_bool($manage_repo)
  validate_bool($manage_resources)

  # Find if listenip is set. If not, we can set to specific ip or
  # to network name. If more than 1 interfaces are available, we
  # can find the ipaddress of this specific interface if listenip
  # is set to for example "eth1" or "bond0.73".
  if ($listenip != undef) {
    if ($listenip =~ /^(eth|bond).*/) {
      $int_name = "ipaddress_${listenip}"
      $listen_ip = inline_template('<%= scope.lookupvar(int_name) %>')
    } elsif is_ip_address($listenip) {
      $listen_ip = $listenip
    } else {
      $listen_ip = undef
    }
  }

  # So if manage_resources is set to true, we can send some data
  # to the puppetdb. We will include an class, otherwise when it
  # is set to false, you'll get warnings like this:
  # "Warning: You cannot collect without storeconfigs being set"
  if $manage_resources {
    class { 'zabbix::resources::proxy':
      hostname  => $hostname,
      ipaddress => $listen_ip,
      use_ip    => $use_ip,
      mode      => $mode,
      port      => $listenport,
      templates => $zbx_templates,
    }
    zabbix::userparameters { 'Zabbix_Proxy':
      template => 'Template App Zabbix Proxy',
    }
  }

  # Get the correct database_type. We need this for installing the
  # correct package and loading the sql files.
  case $database_type {
    'postgresql': {
      $db = 'pgsql'

      # Execute the postgresql scripts
      class { 'zabbix::database::postgresql':
        zabbix_type          => 'proxy',
        zabbix_version       => $zabbix_version,
        database_schema_path => $database_schema_path,
        database_name        => $database_name,
        database_user        => $database_user,
        database_password    => $database_password,
        database_host        => $database_host,
        database_path        => $database_path,
        require              => Package["zabbix-proxy-${db}"],
      }
    }
    'mysql': {
      $db = 'mysql'

      # Execute the mysqll scripts
      class { 'zabbix::database::mysql':
        zabbix_type          => 'proxy',
        zabbix_version       => $zabbix_version,
        database_schema_path => $database_schema_path,
        database_name        => $database_name,
        database_user        => $database_user,
        database_password    => $database_password,
        database_host        => $database_host,
        database_path        => $database_path,
        require              => Package["zabbix-proxy-${db}"],
      }
    }
    'sqlite': {
      $db = 'sqlite3'
    }
    default: {
      fail("Unrecognized database type for proxy: ${database_type}")
    }
  }

  # Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { 'zabbix::repo':
      manage_repo    => $manage_repo,
      zabbix_version => $zabbix_version,
    }
    Package["zabbix-proxy-${db}"] {
      require => Class['zabbix::repo']
    }
  }

  # Now we are going to install the correct packages.
  case $::operatingsystem {
    'redhat','centos','oraclelinux' : {
      package { 'zabbix-proxy':
        ensure  => $zabbix_package_state,
        require => Package["zabbix-proxy-${db}"]
      }
      # Installing the packages
      package { "zabbix-proxy-${db}":
        ensure  => $zabbix_package_state,
      }
    } # END 'redhat','centos','oraclelinux'
    default : {
      # Installing the packages
      package { "zabbix-proxy-${db}":
        ensure  => $zabbix_package_state,
      }
    } # END default
  } # END case $::operatingsystem

  # Workaround for: The redhat provider can not handle attribute enable
  # This is only happening when using an redhat family version 5.x.
  if $::osfamily == 'redhat' and $::operatingsystemrelease !~ /^5.*/ {
    Service[$proxy_service_name] { enable     => true }
  }

  # Controlling the 'zabbix-proxy' service
  service { $proxy_service_name:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package["zabbix-proxy-${db}"],
      File[$include_dir],
      File[$proxy_configfile_path]
    ],
  }

  # if we want to manage the databases, we do
  # some stuff. (for maintaining database only.)
  if $manage_database == true {
    class { 'zabbix::database':
      database_type     => $database_type,
      zabbix_type       => 'proxy',
      database_name     => $database_name,
      database_user     => $database_user,
      database_password => $database_password,
      database_host     => $database_host,
      zabbix_proxy      => $zabbix_proxy,
      zabbix_proxy_ip   => $zabbix_proxy_ip,
      before            => [
        Service[$proxy_service_name],
        Class["zabbix::database::${database_type}"],
      ]
    }
  }

  # Configuring the zabbix-proxy configuration file
  file { $proxy_configfile_path:
    ensure  => present,
    owner   => 'zabbix',
    group   => 'zabbix',
    mode    => '0644',
    notify  => Service[$proxy_service_name],
    require => Package["zabbix-proxy-${db}"],
    replace => true,
    content => template('zabbix/zabbix_proxy.conf.erb'),
  }

  # Include dir for specific zabbix-proxy checks.
  file { $include_dir:
    ensure  => directory,
    require => File[$proxy_configfile_path],
  }

  # Manage firewall
  if $manage_firewall {
    firewall { '151 zabbix-proxy':
      dport  => $listenport,
      proto  => 'tcp',
      action => 'accept',
      state  => ['NEW','RELATED', 'ESTABLISHED'],
    }
  }
}
