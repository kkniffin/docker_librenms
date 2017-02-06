# LibreNMS

## Example append.config.php

### Add community
  $config['snmp']['community'][] = "mycommunity";

### List of RFC1918 networks to allow scanning-based discovery
$config['nets'][] = "10.0.0.0/8";  
$config['nets'][] = "172.16.0.0/12";  
$config['nets'][] = "192.168.0.0/16";  

# Append Domain Name if Short Name Received
  $config['mydomain'] = 'test.local';  


