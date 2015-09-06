# the aide class manages some the configuration of aide
class aide (
  $package                         = 'aide',
  $version                         = 'installed',
  $conf_path                       = $aide::params::conf_path,
  $db_dir                          = '/var/lib/aide',
  $db_file                         = '/var/lib/aide/aide.db.gz',
  $db_out                          = '/var/lib/aide/aide.db.new.gz',
  $db_new                          = '/var/lib/aide/aide.db.new.gz',
  $cron_script_template            = undef,
  $cron_script_target              = undef,
  $gzip_dbout                      = 'yes',
  $verbose                         = '5',
  $report_url                      = [ 'file:/var/lib/aide/aide.log' ],
  $summarize_changes               = 'yes',
  $initialize                      = true,
  $init_nice                       = '19',
) inherits aide::params {

  validate_absolute_path($db_dir)
  validate_absolute_path($db_file)
  validate_absolute_path($db_out)
  validate_absolute_path($db_new)
  validate_re($gzip_dbout, '^(yes|no)$')
  validate_re($verbose, '^\d+')
  validate_re($summarize_changes, '^(yes|no)$')

  include '::aide::package'
  include '::aide::config'
  include '::aide::initialize'

  if $initialize {
    include '::aide::initialize'
    Class['::aide::config'] ~>
    Class['::aide::initialize']
  }

  if $cron_script_template {
    validate_absolute_path($cron_script_target)
    include '::aide::cron'
    Class['::aide::config'] ->
    Class['::aide::cron']
  }

  anchor { 'aide::begin': } ->
  Class['::aide::package'] ->
  Class['::aide::config'] ->
  anchor { 'aide::end': }

}
