# puppet-aide

## Overview

This is a fork of [mklauber-aide](https://forge.puppetlabs.com/mklauber/aide/)

`aide` is a puppet module for managing Aide (Advanced Intrustion Detection
Environment). It allows you to define Rules and File/folder watches via defined
types.  Refer to the Aide
[manual](http://aide.sourceforge.net/stable/manual.html) for details about Aide
configuration options.

Difference between the _puppet-aide_ fork and the original module:

* Add more configuration options, including gzip, verbose, and summarized
  changes.
* Make cron management optional
* Allow a custom script to be managed by the module for a cron job
* Make initializing optional (first run creation of database)
* Allow the initialization to run with 'nice'
* Support multiple `report_url` configurations
* Rename variables to map to the AIDE config file values
* Add parameter validation
* Syntax fixups
* Remove the cron resources. It was not flexible enough to make sense here, imo

## Usage

### 1. Declare the base class

```puppet
class { '::aide':
  cron_script_template => 'profile/base/linux/aide.cron.sh.erb',
  cron_script_target   => '/etc/cron.weekly/aide',
}
```

### 2. Manage rules

```puppet
aide::rule { 'NORMAL':
  rules => [ 'p','u','g','s','md5' ],
}
```

### 3. Manage files to monitor

```puppet
aide::watch { '/boot':
  rules => [ 'NORMAL' ],
}
```

## Examples

### Create a rule to exlude directories

```puppet
aide::watch { '/var/log':
  type => 'exclude'
}
```

This with ignore all files under /var/log.  It adds the line `!/var/log` to the config file.

### Create a rule to specify only specific files

```puppet
aide::watch { '/var/log/messages':
  type => 'equals',
  rules => 'MyRule'
}
```

This with watch only the file /var/log/messages.  It will ignore /var/log/messages/thingie.  It adds the line `=/var/log/messages MyRule` to the config file.


## Reference

### Class: `aide`

__package__

Default: 'aide'

The name of the package to manage.

__version__

Default: 'installed'

The state of the package to manage.  Could be a version number, 'present',
or 'latest', for example.  Uses operating system repositories with a `package`
resource.

__conf_path__

Default: Refer to [manifests/params.pp](manifests/params.pp)

The path to the AIDE configuration file (aide.conf).

__db_dir__

Default: '/var/lib/aide'

Absolute path the the AIDE databases.

__db_file__

Default: '/var/lib/aide/aide.db.gz'

Maps to the AIDE configuration option.

__db_out__

Default: '/var/lib/aide/aide.db.new.gz'

Maps to the AIDE configuration option.

__db_new__

Default: '/var/lib/aide/aide.db.new.gz'

Maps to the AIDE configuration option.

__cron_script_template__

Default: undef

If provided, this should point to a template file (.erb) to use as a script
for running AIDE.  A script isn't provided by the module, as they vary.
Usually, a cron script will run a check, update the database with the current
state, and send a report.

The point here is to let you manage your own cron script but use the
parameter values from this module in it.

Example: `profile/base/linux/aide.cron.erb`

__cron_script_target__

Default: undef

If `cron_script_template` is provided, this parameter should be set to an
absolute path to manage the script.

Example: `/etc/cron.weekly/aide`

__gzip_dbout__

Default: 'yes'

Maps to the AIDE configuration option.

__verbose__

Default: '5'

Maps to the AIDE configuration option.

__report_url__

Default: [ 'file:/var/lib/aide/aide.log' ]

An array of places to send the report.  For example, a static file (as seen
here) and syslog.

__summarize_changes__

Default: 'yes'

Maps to the AIDE configuration option.

__initialize__

Default: true

Whether this module should be responsible for the initialization of the AIDE
database.  This will have Puppet execute the `aide -i` to create the database
and copy that database to the `db_out` location for comparison.

Note that this initialization can take quite a while and cause quite a bit of
system load.

__init_nice__

Default: '19'

If `initialize` is true, this value should be a value for the `nice` command
for running it.  Refer to the `nice` man page for information.  Basically,
-19 gives it the highest priority and 19 gives it last priority.

### Defined type: `aide::rule`

__rules__

An array containing the rules.

For example:

```puppet
aide::rule { 'NORMAL':
  rules => [ 'p','u','g','s','md5' ],
}
```

Refer to AIDE's man page to determine what the rule values mean.

### Defined type: `aide::watch`

__path__

Defaults to $title

__type__

Default: 'regular'

Valid values: regular, equals, exclude

'regular' is a regular watched resource. Equals will watch the explicit
resource, not recursively.  Exclude will exclude the resource.

__rules__

Default: undef

The rules to apply to this watched resource
