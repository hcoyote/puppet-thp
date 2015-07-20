# == Class: thp
#
# Module to manage Transparent Huge Pages (THP)
#
# This allows you to enable or disable THP and THP Defragmentation
#
class thp (
  $config_path  = '/etc/sysconfig/thp',
  $config_owner = 'root',
  $config_group = 'root',
  $config_mode  = '0644',
  $service_name = 'thp',
  $service_ensure = 'stopped',
  $service_enable = true,
  $service_init_path = '/etc/init.d',
  $service_init_owner = 'root',
  $service_init_group = 'root',
  $service_init_mode  = '0755',
  $thp_status = 'always',
  $thp_defrag_status = 'always',
) {

    # make sure our config file parameters are valid.
    validate_absolute_path($config_path)
    validate_string($config_owner)
    validate_string($config_group)
    validate_re($config_mode, '^(\d){4}$', "nscd::config_mode is <${config_mode}>. Must be in four digit octal notation.")

    # make sure our service init file parameters are valid.
    validate_absolute_path($service_init_path)
    validate_string($service_init_owner)
    validate_string($service_init_group)
    validate_re($service_init_mode, '^(\d){4}$', "nscd::service_init_mode is <${service_init_mode}>. Must be in four digit octal notation.")

    # make sure our service name parameters are valid.
    validate_string($service_name)
    validate_re($service_ensure, '^(present)|(running)|(absent)|(stopped)$', 'thp::service_ensure is invalid and does not match the regex.')

    if type($service_enable) == 'String' {
      $service_enable_real = str2bool($service_enable)
    } else {
      $service_enable_real = $service_enable
    }
    validate_bool($service_enable_real)

    # make sure our thp configuration options are valid.
    validate_re($thp_status, '^(always)|(never)|(madvise)$', 'thp::thp_status is invalid and does not match the regex.')
    validate_re($thp_defrag_status, '^(always)|(never)|(madvise)$', 'thp::thp_status is invalid and does not match the regex.')


    case $::osfamily {
        'RedHat': {
            case $::lsbmajdistrelease {
              '5': { fail("${::osfamily} ${::lsbmajdistrelease} does not have Transparent Huge Page support") }
              '6': { }
            }
        }
        default: {
            fail("Unsupported osfamily. I don't know how to configure Transparent Huge Page support for ${::osfamily}")
        }
    }


    file {'thp_sysconfig_path':
        ensure  => file,
        path    => $config_path,
        content => template('thp/thp_sysconfig.erb'),
        owner   => $config_owner,
        group   => $config_group,
        mode    => $config_mode,
    }

    file {'thp_initd_path':
        ensure  => file,
        path    => "${service_init_path}/${service_name}",
        content => template('thp/thp_initd.erb'),
        owner   => $service_init_owner,
        group   => $service_init_group,
        mode    => $service_init_mode,
    }

    service {'thp_service':
        ensure    => $service_ensure,
        name      => $service_name,
        enable    => $service_enable_real,
        subscribe => File['thp_sysconfig_path'],
    }
}
