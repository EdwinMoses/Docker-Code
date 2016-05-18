#puppet-zabbix

####Table of Contents

1. [Overview](#overview)
2. [Upgrade from 0.x.x to 1.x.x](#upgrade)
3. [Module Description - What the module does and why it is useful](#module-description)
4. [Setup - The basics of getting started with the zabbix module](#setup)
 	* [zabbix-server](#setup-zabbix-server)
 	* [zabbix-agent](#setup-zabbix-agent)
 	* [zabbix-proxy](#setup-zabbix-proxy)
 	* [zabbix-javagateway](#setup-zabbix-javagateway)
        * [zabbix-userparameters](#setup-userparameters)
 	* [zabbix-template](#setup-template)
5. [Usage - Configuration options and additional functionality](#usage)
    * [zabbix-server](#usage-zabbix-server)
    * [zabbix-agent](#usage-zabbix-agent)
    * [zabbix-proxy](#usage-zabbix-proxy)
    * [zabbix-javagateway](#usage-zabbix-javagateway)
    * [zabbix-userparameters](#usage-zabbix-userparameters)
    * [zabbix-template](#usage-zabbix-template)
6. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [zabbix-server](#reference-zabbix-server)
    * [zabbix-agent](#reference-zabbix-agent)
    * [zabbix-proxy](#reference-zabbix-proxy)
    * [zabbix-javagateway](#reference-zabbix-javagateway)
    * [zabbix-userparameters](#reference-zabbix-userparameters)
    * [zabbix-template](#reference-zabbix-template)
7. [Limitations - OS compatibility, etc.](#limitations)
8. [Development - Contributors](#contributors)
9. [Notes](#note)
    * [Some overall notes](#standard-usage)
    * [When using exported resources | manage_resources is true](#when-using-exported-resources)

##Overview

This module contains the classes for installing and configuring the following zabbix components:

  - zabbix-server
  - zabbix-agent
  - zabbix-proxy
  - zabbix-javagateway

##Module Description
When using this module, you can monitor your whole environment with zabbix. It can install the various zabbix components like the server and agent, but you will also be able to install specific "userparameter" file which zabbix can use for monitoring.  

With the 0.4.0 release, you can - when you have configured exported resources - configure agents and proxies in the webinterface. So when you add an zabbix::agent to an host, it first install the agent onto the host. It will send some data to the puppetdb and when puppet runs on the zabbix-server it will create this new host via the zabbix-api.

Be aware when you have a lot of hosts, it will increase the puppet runtime on the zabbix-server host. It will check via the zabbix-api if hosts exits and costs time.

This module make uses of this gem: https://github.com/express42/zabbixapi
With this gem it is possible to create/update hosts/proxy in ruby easy.

##Upgrade
With release 1.0.0 the zabbix::server class is split into 3 classes:
 - zabbix::web
 - zabbix::server
 - zabbix::database

Now you can use 3 machines for each purpose. This is something for the bigger environments to spread the load.

When upgrading from 0.x.x to 1.x.x, be aware of the following changes:
  - Choose the correct zabbix setup for your environment *:
    - Single node
    - Multi node
  - Path changes for the database ".done" file. Create the following files in /etc/zabbix/:
    - /etc/zabbix/.schema.done
    - /etc/zabbix/.images.done
    - /etc/zabbix/.data.done
  - Rename of the following parameters:
    - dbtype --> database_type
    - dbhost --> database_host
    - dbuser --> database_user
    - dbpass --> database_password
    - dbschema --> database_schema
    - dbname --> database_name
    - dbsocket --> database_socket
    - dbport --> database_port

\* check [this](#usage-zabbix-server) document/paragraph how to setup your environment. There were multiple changes to make this work (Like moving parameters to other (new) classes).

In case I missed something, please let me know and will update this document.

##Setup
As this puppet module contains specific components for zabbix, you'll need to specify which you want to install. Every zabbix component has his own zabbix:: class. Here you'll find each component.

###Setup zabbix-server
This will install an basic zabbix-server instance. You'll have to decide if you want to run everything on a single host or multiple hosts. When installing on a single host, the 'zabbix' class can be used. When you want to use more than 1 host, you'll need the following classes:
  - zabbix::web
  - zabbix::server
  - zabbix::database

You can see at "usage" in this documentation how all of this can be achieved.

You will need to supply one parameter: zabbix_url. This is the url on which the zabbix instance will be available. With the example at "setup", the zabbix webinterface will be: http://zabbix.example.com.

When installed succesfully, zabbix web interface will be accessable and you can login with the default credentials:

Username: Admin
Password: zabbix

###Setup zabbix-agent
This will install the zabbix-agent. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server (or zabbix-proxy if this is used.). Default is 127.0.0.1, which only works for the zabbix agent when installed on the same host as zabbix-server (or zabbix-proxy).

###Setup zabbix-proxy
This will install an zabbix-proxy instance. It will need at least 1 parameter to function, the name or ipaddress of the zabbix-server. Default is 127.0.0.1, which wouldn't work. Be aware, the zabbix::proxy can't be installed on the same server as zabbix::server.

###Setup zabbix-javagateway
This will install the zabbix java gateway for checking jmx items. It can run without any parameters.

When using zabbix::javagateway, you'll need to add the 'javagateway' parameter and assign the correct ip address for the zabbix::server or zabbix::proxy instance.

###Setup userparameters
You can use userparameter files (or specific entries) to install it into the agent.
Also added with the 0.6.0 release is an class zabbix::userparameter. This class can be used with Hiera or The Foreman when you want to install userparameter files.

###Setup template
You can upload and install Zabbix Templates automatically via the Zabbix API. With this, you Zabbix templates are always up2date.

##Usage
The following will provide an basic usage of the zabbix components.
###Usage zabbix-server

The zabbix-server can be used in 2 ways:
* one node setup
* multiple node setup.

The following is an example of an single node setup:
```ruby
node 'zabbix.example.com'
  class { 'apache':
    mpm_module => 'prefork',
  }
  include apache::mod::php

  class { 'postgresql::server': }
  #class { 'mysql::server': }

  class { 'zabbix':
    zabbix_url    => 'zabbix.example.com',
    #database_type => 'mysql',
  }
}
```

The setup of above assumes you are using an PostgreSQL database. When you want to use the MySQL database, you'll need to do the following:
* comment the 'postgresql::server' class
* uncomment the 'mysql::server' class
* Uncomment the database_type parameter in the zabbix class (Or make sure that it is set to 'mysql').

When using an multiple node setup, the following can be used:
```ruby
node 'server01.example.com' {
# My ip: 192.168.20.11
  class { 'apache':
      mpm_module => 'prefork',
  }
  class { 'apache::mod::php': }
  class { 'zabbix::web':
    zabbix_url    => 'zabbix.dj-wasabi.nl',
    zabbix_server => 'server02.example.com',
    database_host => 'server03.example.com',
    database_type => 'mysql',
  }
}

node 'server02.example.com' {
# My ip: 192.168.20.12
  #class { 'postgresql::client': }
  class { 'mysql::client': }
  class { 'zabbix::server':
    database_host  => 'server03.example.com',
    database_type  => 'mysql',
  }
}

node 'server03.example.com' {
# My ip: 192.168.20.13
  #class { 'postgresql::server':
  #    listen_addresses => '192.168.20.13'
  #  }
    class { 'mysql::server':
      override_options => {
        'mysqld'       => {
          'bind_address' => '192.168.20.13',
        },
      },
    }
  class { 'zabbix::database':
    database_type    => 'mysql',
    #zabbix_web_ip    => '192.168.20.12',
    #zabbix_server_ip => '192.168.20.13',
    zabbix_server    => 'server02.example.com',
    zabbix_web       => 'server01.example.com',
  }
}
```

The setup of above assumes you are using an MySQL database. When you want to use the PostgreSQL database, you'll need to do the following:
* Uncomment the postgresql* classes
* remove/comment the mysql* classes
* remove or change the `database_type` parameter to 'postgresql'
* uncomment both zabbix_*_ip parameters and comment the zabbix_server and zabbix_web parameter.

###Usage zabbix-agent

Basic one way of setup, wheter it is monitored by zabbix-server or zabbix-proxy:
```ruby
class { 'zabbix::agent':
  server => '192.168.20.11',
}
```

###Usage zabbix-proxy

Like the zabbix-server, the zabbix-proxy can also be used in 2 ways:
* single node
* multiple node

The following is an example of an single node setup:
```ruby
node 'proxy.example.com'
  class { 'postgresql::server': }
  #class { 'mysql::server': }

  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    zabbix_server_port => '10051',
    #database_type      => 'mysql',
  }
}
```

The setup of above assumes you are using an PostgreSQL database. When you want to use the MySQL database, you'll need to do the following:
* comment the 'postgresql::server' class
* uncomment the 'mysql::server' class
* Uncomment the database_type parameter in the zabbix class (Or make sure that it is set to 'mysql').

When using an multiple node setup, the following can be used:
```ruby
node 'server11.example.com' {
# My ip: 192.168.30.11
  #class { 'postgresql::client': }
  class { 'mysql::client': }
  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    manage_database    => false,
    database_host      => 'server12.example.com',
    database_type      => 'mysql',
  }
}

node 'server12.example.com' {
# My ip: 192.168.30.12
  #class { 'postgresql::server':
  #    listen_addresses => '192.168.30.12'
  #  }
    class { 'mysql::server':
      override_options => {
        'mysqld'       => {
          'bind_address' => '192.168.30.12',
        },
      },
    }
  class { 'zabbix::database':
    database_type     => 'mysql',
    zabbix_type       => 'proxy',
    #zabbix_proxy_ip   => '192.168.30.11',
    zabbix_proxy      => 'server11.example.com',
    database_name     => 'zabbix-proxy',
    database_user     => 'zabbix-proxy',
    database_password => 'zabbix-proxy',
  }
}
```

The setup of above assumes you are using an MySQL database. When you want to use the PostgreSQL database,
you'll need to do the following:
* Uncomment the postgresql* classes
* remove/comment the mysql* classes
* remove or change the `database_type` to 'postgresql'
* uncomment both zabbix_proxy_ip parameter and comment the zabbix_proxy.

###Usage zabbix-javagateway

The zabbix-javagateway can be used with an zabbix-server or zabbix-proxy. You'll need to install it on an server. (Can be together with zabbix-server or zabbix-proxy, you can even install it on a sperate machine.). The following example shows you to use it on a seperate machine.

```ruby
node server05.example.com {
# My ip: 192.168.20.15
  class { 'zabbix::javagateway': }
}
```

When installed on seperate machine, the zabbix::server configuration should be updated by adding the `javagateway` parameter.

```ruby
node server01.example.com {
  class { 'zabbix::server':
    zabbix_url  => 'zabbix.example.com',
    javagateway => '192.168.20.15',
  }
}
```

Or when using with an zabbix-proxy:

```ruby
node server11.example.com {
  class { 'zabbix::proxy':
    zabbix_server_host => '192.168.20.11',
    javagateway        => '192.168.20.15',
  }
}
```
###Usage zabbix-userparameters
Using an 'source' file:

```ruby
zabbix::userparameters { 'mysql':
  source => 'puppet:///modules/zabbix/mysqld.conf',
}
```

Or for example when you have just one entry:

```ruby
zabbix::userparameters { 'mysql':
  content => 'UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive',
}
```

Using an [LLD](https://www.zabbix.com/documentation/2.4/manual/discovery/low_level_discovery) 'script' file:

```ruby
zabbix::userparameters { 'lld_snort.sh':
  script => 'puppet:///modules/zabbix/lld_snort.sh',
}
```

When you are using Hiera or The Foreman, you can use it like this:
```yaml
zabbix::userparameter::data:
  MySQL:
    content: UserParameter=mysql.ping,mysqladmin -uroot ping | grep -c alive
```

###Usage zabbix-template

With the 'zabbix::template' define, you can install Zabbix templates via the API. You'll have to make sure you store the XML file somewere on your puppet server or in your module.

Please be aware that you can only make use of this feature when you have configured the module to make use of exported resources.

You can instal the MySQL template xml via the next example:
```ruby
zabbix::template { 'Template App MySQL':
  templ_source => 'puppet:///modules/zabbix/MySQL.xml'
}
```

##Reference
There are some overall parameters which exists on all of the classes:
* `zabbix_version`: You can specify which zabbix release needs to be installed. Default is '2.4'.
  ```ruby
  # sepcify the version and pass it to each class that uses the parameter
  $zabbix_vesion = '2.2'

  class { 'zabbix::repo':
    zabbix_version => $zabbix_version,
  }

  class { 'zabbix':
    zabbix_version => $zabbix_version,
  }
  ```

* `manage_firewall`: Wheter you want to manage the firewall. If true, iptables will be configured to allow communications to zabbix ports. (Default: False)
* `manage_repo`:  If zabbix needs to be installed from the zabbix repositories (Default is true). When you have your own repositories, you'll set this to false. But you'll have to make sure that your repositorie is installed on the host.
  ```ruby
  class { 'zabbix::repo':
    manage_repo => false,
  }
  ```


The following is only availabe for the following classes: zabbix::web, zabbix::proxy & zabbix::agent
* `manage_resources`: As of release 0.4.0, when this parameter is set to true (Default is false) it make use of exported resources. You'll have an puppetdb configured before you can use this option. Information from the zabbix::agent, zabbix::proxy and zabbix::userparameters are able to export resources, which will be loaded on the zabbix::server.
* `database_type`: Which database is used for zabbix. Default is postgresql.
* `manage_database`: When the parameter 'manage_database' is set to true (Which is default), it will create the database and loads the sql files. Default the postgresql will be used as backend, mentioned in the params.pp file. You'll have to include the postgresql (or mysql) module yourself, as this module will require it.


###Reference zabbix (init.pp)
This is the class for installing everything on a single host and thus all parameters described earlier and those below can be used with this class.

###Reference zabbix-web
* `zabbix_url`: This is the url on which Zabbix should be available. Please make sure that the entry exists in the DNS configuration.
* `zabbix_timezone`: On which timezone the machine is placed. This information is needed for the apache virtual host.
* `manage_vhost`: Will create an apache virtual host. Default is true.
* `apache_use_ssl`: Will create an ssl vhost. Also nonssl vhost will be created for redirect nonssl to ssl vhost.
* `apache_ssl_cert`: The location of the ssl certificate file. You'll need to make sure this file is present on the system, this module will not install this file.
* `apache_ssl_key`: The location of the ssl key file. You'll need to make sure this file is present on the system, this module will not install this file.
* `apache_ssl_cipher`: The ssl cipher used. Cipher is used from: https://wiki.mozilla.org/Security/Server_Side_TLS.
* `apache_ssl_chain`: The ssl_chain file. You'll need to make sure this file is present on the system, this module will not install this file.
* `apache_php_max_execution_time`: Max execution time for php.
* `apache_php_memory_limit`: PHP memory size limit.
* `apache_php_upload_max_filesize`: HP maximum upload filesize.
* `apache_php_max_input_time`: Max input time for php.
* `apache_php_always_populate_raw_post_data`: Default: -1
* `zabbix_api_user`: Username of user in Zabbix which is able to create hosts and edit hosts via the zabbix-api. Default: Admin
* `zabbix_api_pass`: Password for the user in Zabbix for zabbix-api usage. Default: zabbix
* `zabbix_template_dir`: The directory where all templates are stored before uploading via API

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-server
* `database_path`: When database binaries are not in $PATH, you can use this parameter to append `database_path` to $PATH

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-agent
* `server`: This is the ipaddress of the zabbix-server or zabbix-proxy.

The following parameters is only needed when `manage_resources` is set to true:
* `monitored_by_proxy`: When an agent is monitored via an proxy, enter the name of the proxy. The name is found in the webinterface via: Administration -> DM. If it isn't monitored by an proxy or `manage_resources` is false, this parameter can be empty.
* `agent_use_ip`: Default is set to true. Zabbix server (or proxy) will connect to this host via ip instead of fqdn. When set to false, it will connect via fqdn.
* `zbx_group`: Name of the hostgroup on which the agent will be installed. There can only be one hostgroup defined and should exists in the webinterface. Default: Linux servers
* `zbx_templates`: Name of the templates which will be assigned when agent is installed. Default (Array): 'Template OS Linux', 'Template App SSH Service'

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-proxy
* `zabbix_server_host`: The ipaddress or fqdn of the zabbix server.
* `database_path`: When database binaries are not in $PATH, you can use this parameter to append `database_path` to $PATH

The following parameters is only needed when `manage_resources` is set to true:
* `use_ip`: Default is set to true.
* `zbx_templates`: List of templates which are needed for the zabbix-proxy. Default: 'Template App Zabbix Proxy'
* `mode`: Which kind of proxy it is. 0 -> active, 1 -> passive

There are some more zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-javagateway
There are some zabbix specific parameters, please check them by opening the manifest file.

###Reference zabbix-userparameters

* `source`: File which holds several userparameter entries.
* `content`: When you have 1 userparameter entry which you want to install.
* `script`: Low level discovery (LLD) script.
* `script_dir`:  The script extention. Should be started with the dot. Like: .sh .bat .py
* `template`: When you use exported resources (when manage_resources on other components is set to true) you'll can add the name of the template which correspondents with the 'content' or 'source' which you add. The template will be added to the host.
* `script_dir`: When `script` is used, this parameter can provide the directly where this script needs to be placed. Default: '/usr/bin'

###Reference zabbix-template

* `templ_name`: The name of the template. This name will be found in the Web interface.
* `templ_source`: The location of the XML file wich needs to be imported.

##limitations
The module is only supported on the following operating systems:

Zabbix 2.4:

  * CentOS 6.x, 7.x
  * Amazon 6.x, 7.x
  * RedHat 6.x, 7.x
  * OracleLinux 6.x, 7.x
  * Scientific Linux 6.x, 7.x
  * Ubuntu 14.04
  * Debian 7

Zabbix 2.2:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Scientific Linux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 7
  * xenserver 6

Zabbix 2.0:

  * CentOS 5.x, 6.x
  * RedHat 5.x, 6.x
  * OracleLinux 5.x, 6.x
  * Scientific Linux 5.x, 6.x
  * Ubuntu 12.04
  * Debian 6, 7
  * xenserver 6

This module is supported on both the community as the Enterprise version of Puppet.

Zabbix 1.8 isn't supported (yet) with this module.

Ubuntu 10.4 is officially supported by zabbix for Zabbix 2.0. I did have some issues with making it work, probably in a future release it is supported with this module as well.

Please be aware, that when manage_resources is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts.

##Contributors
The following have contributed to this puppet module:
 * Suff
 * gattebury
 * sq4ind
 * nburtsev
 * actionjack
 * karolisc
 * lucas42
 * f0
 * mmerfort
 * genebean
 * meganuke19
 * fredprod
 * JvdW
 * rleemorlang
 * genebean
 * exptom
 * sbaryakov
 * roidelapluie
 * andresvia
 * ju5t
 * elricsfate
 * IceBear2k
 * altvnk
 * rnelson0 
 * hkumarmk
 * Wprosdocimo
 * 1n
 * szemlyanoy
 * Wprosdocimo
 * sgnl05
 * hmn
 * BcTpe4HbIu
 * mschuett

Many thanks for this!
(If I have forgotten you, please let me know and put you in the list of fame. :-))


##Note
###Standard usage
*	Not specified as required but for working correctly, the epel repository should be available for the 'fping'|'fping6' packages.
*	Make sure you have sudo installed and configured with: !requiretty.
*   Make sure that selinux is permissive or disabled.


###When using exported resources

At the moment of writing, the puppet run will fail one or more times when `manage_resources` is set to true when you install an fresh Zabbix server. It is an issue and I'm aware of it. Don't know yet how to solve this, but someone suggested to try puppet stages and for know I haven't made it work yet.

*	Please be aware, that when `manage_resources` is enabled, it can increase an puppet run on the zabbix-server a lot when you have a lot of hosts.
*	First run of puppet on the zabbix-server can result in this error:

```ruby
Error: Could not run Puppet configuration client: cannot load such file -- zabbixapi
Error: Could not run: can't convert Puppet::Util::Log into Integer
```

See: http://comments.gmane.org/gmane.comp.sysutils.puppet.user/47508, comment:  Jeff McCune | 20 Nov 20:42 2012

```quote
This specific issue is a chicken and egg problem where by a provider needs a gem, but the catalog run itself is the thing that provides the gem dependency. That is to say, even in Puppet 3.0 where we delay loading all of the providers until after pluginsync finishes, the catalog run hasn't yet installed the gem when the provider is loaded.

The reason I think this is basically a very specific incarnation of #6907 is because that ticket is pretty specific from a product functionality perspective, "You should not have to run puppet twice to use a provider."
```

After another puppet run, it will run succesfully.

* On a Red Hat family server, the 2nd run will sometimes go into error:

```ruby
Could not evaluate: Connection refused - connect(2)
```

When running puppet again (for 3rd time) everything goes fine.
