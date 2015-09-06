# the aide class manages some the configuration of aide
class aide (
  $package                         = 'aide',
  $version                         = 'installed',
  $conf_path                       = $aide::params::conf_path,
  $db_dir                          = '/var/lib/aide',
  $db_file                         = '/var/lib/aide/aide.db.gz',
  $db_out                          = '/var/lib/aide/aide.db.new.gz',
  $db_new                          = '/var/lib/aide/aide.db.new.gz',
  $manage_cron                     = true,
  $cron_template                   = undef,
  $hour                            = '0',
  $gzip_dbout                      = 'yes',
  $verbose                         = '5',
  $report_url                      = [ 'file:/var/lib/aide/aide.log' ],
  $summarize_changes               = 'yes',
) inherits aide::params {

  include '::aide::install'
  include '::aide::config'
  include '::aide::firstrun'

  if $manage_cron or $cron_template {
    include '::aide::cron'
    Class['::aide::firstrun'] ->
    Class['::aide::cron']
  }

  anchor { 'aide::begin': } ->
  Class['::aide::install'] ->
  Class['::aide::config'] ~>
  Class['::aide::firstrun'] ->
  anchor { 'aide::end': }

}
