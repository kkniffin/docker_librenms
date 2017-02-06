<?php
## Have a look in defaults.inc.php for examples of settings you can set here. DO NOT EDIT defaults.inc.php!

### Database config
$config['db_host'] = getenv('LIBRENMS_CONFIG_PHP_DBHOST');
$config['db_port'] = getenv('LIBRENMS_CONFIG_PHP_DBPORT');
$config['db_user'] = getenv('LIBRENMS_CONFIG_PHP_DBUSER');
$config['db_pass'] = getenv('LIBRENMS_CONFIG_PHP_DBPASS');
$config['db_name'] = getenv('LIBRENMS_CONFIG_PHP_DB');
$config['db']['extension'] = "mysqli";// mysql or mysqli

// This is the user LibreNMS will run as
//Please ensure this user is created and has the correct permissions to your install
$config['user'] = 'librenms';

### Memcached config - We use this to store realtime usage
$config['memcached']['enable']  = FALSE;
$config['memcached']['host']    = "localhost";
$config['memcached']['port']    = 11211;

### Locations - it is recommended to keep the default
$config['install_dir']  = "/opt/librenms";

### This should *only* be set if you want to *force* a particular hostname/port
### It will prevent the web interface being usable form any other hostname
$config['base_url']        = getenv('LIBRENMS_CONFIG_PHP_BASEURL');

### Enable this to use rrdcached. Be sure rrd_dir is within the rrdcached dir
### and that your web server has permission to talk to rrdcached.
$config['rrdcached']    = "unix:/var/run/rrdcached/rrdcached.sock";

### Default community
$config['snmp']['community'][] = "public";

### Authentication Model
$config['auth_mechanism'] = "mysql"; # default, other options: ldap, http-auth
#$config['http_auth_guest'] = "guest"; # remember to configure this user if you use http-auth

### List of RFC1918 networks to allow scanning-based discovery
#$config['nets'][] = "10.0.0.0/8";
#$config['nets'][] = "172.16.0.0/12";
#$config['nets'][] = "192.168.0.0/16";

# Uncomment the next line to disable daily updates
#$config['update'] = 0;

# Check for Duplicate IP's and Don't Add if duplicate
$config['addhost_alwayscheckip']   = false;

# Add Devices even if there isn't a reverse DNS entry
$config['discovery_by_ip'] = true;

# Allow Duplicate SysName
$config['allow_duplicate_sysName'] = true;
