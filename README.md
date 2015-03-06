# puppet-module-thp
===

Puppet module to manage Transparent Huge Pages on RHEL6/CentOS6 and higher

===

# Compatibility
---------------
This module is built for use with Puppet v3 on the following platforms and supports Ruby versions 1.8.7, 1.9.3, and 2.0.0.

* EL 6

===

# Parameters
------------
All numbers should be type cast as strings. Each per service option can be accessed as parameters and follow the naming scheme of `<service>_<option>` with the dashed changed to underscores. So enable-cache for the passwd service is available as `passwd_enable_cache`. The default values follow that of the man page, unless otherwise noted.

## Resource parameters
---

config_path
-----------
Path to sysconfig thp

- *Default*: '/etc/sysconfig/thp'

config_owner
------------
Owner of sysconfig thp.

- *Default*: 'root'

config_group
------------
Group of sysconfig thp.

- *Default*: 'root'

config_mode
-----------
Mode of sysconfig thp. Must be in four digit octal notation.

- *Default*: '0644'

service_name
------------
String or array for name of service(s).

- *Default*: 'thp'

service_ensure
--------------
String for value of ensure attribute of thp service. Valid values are 'present', 'running', 'absent', or 'stopped'.

*Note*: This does not actually run a service

- *Default*: 'stopped'

service_enable
--------------
Value of enable attribute of thp service. This determines if the service will start at boot or not. Allows for boolean, 'true', or 'false'.

- *Default*: true

service_init_path
-----------------
Value of the default init.d path

- *Default*: '/etc/init.d'

service_init_owner
------------------
Owner of sysconfig thp.

- *Default*: 'root'

service_init_group
------------------
Group of sysconfig thp.

- *Default*: 'root'

service_init_mode
-----------------
Mode of sysconfig thp. Must be in four digit octal notation.

- *Default*: '0755'

thp_status
----------
Kernel configuration option to enable or disable Transparent Huge Pages by setting a value in /sys/kernel/mm/transparent_hugepage/enabled.  Valid values are 'always' or 'never'

- *Default*: 'always'

thp_defrag_status
----------
Kernel configuration option to enable or disable Transparent Huge Pages Defragmentation by setting a value in /sys/kernel/mm/transparent_hugepage/defrag.  Valid values are 'always' or 'never'

- *Default*: 'always'

## Usage with Hiera

Because this is a parameterized class, you can use hiera to override the
defaults.  This is primarily to allow for modifying thp_status and
thp_defrag_status from defaults.  To do this, include the thp module somewhere
in your manifests and then set the following options in your hiera YAML
configuration.

    thp::thp_status: 'always'
    thp::thp_defrag_status: 'never'
