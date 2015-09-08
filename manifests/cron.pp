# Class for managing aide's cron job.
class aide::cron inherits aide {

  if $::aide::cron_script_template {
    file { 'aide.cron.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0700',
      path    => $::aide::cron_script_target,
      content => template($::aide::cron_script_template),
    }
  }

}
