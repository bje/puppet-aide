# Class for managing aide's cron job.
class aide::cron inherits aide {

  if $cron_template {
    file { '/usr/local/bin/aide.cron.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      content => template($cron_template),
    }
  }

  if $manage_cron {
    cron { 'aide':
      command => "${::aide::params::aide_path} --check",
      user    => 'root',
      hour    => $::aide::hour,
    }
  }

}
