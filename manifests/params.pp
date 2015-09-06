# aide::params sets the default values for parameters.
class aide::params {
  case $::osfamily {
    'Debian': {
      $aide_path = '/usr/bin/aide'
      $conf_path = '/etc/aide/aide.conf'
    }
    'Redhat': {
      $aide_path = '/usr/sbin/aide'
      $conf_path = '/etc/aide.conf'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
