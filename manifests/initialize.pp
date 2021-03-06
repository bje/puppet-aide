class aide::initialize inherits aide {
  exec { 'aide init':
    command => "nice -n ${::aide::init_nice} ${::aide::params::aide_path} --init --config ${::aide::conf_path}",
    user    => 'root',
    creates => $::aide::db_out,
    path    => '/bin:/usr/bin',
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
