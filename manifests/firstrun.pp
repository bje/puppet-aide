# the aide::firstrun class creates the database that will be used for future checks.
class aide::firstrun inherits aide {
  exec { 'aide init':
    command     => "${::aide::params::aide_path} --init --config ${::aide::conf_path}",
    user        => 'root',
    creates     => $::aide::db_out,
  }

  file { $::aide::db_file:
    ensure    => 'file',
    owner     => 'root',
    group     => 'root',
    mode      => '0400',
    source    => $::aide::db_out,
    replace   => false,
    subscribe => Exec['aide init'],
  }

}
