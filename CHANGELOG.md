## puppet/aide-2.0.2

 - Fix filename for initialize
 - Add newlines after exclude rules

## puppet/aide-2.0.0

 - Add more configuration options, including gzip, verbose, and summarized changes.
 - Make cron management optional
 - Allow a custom script to be managed by the module for a cron job
 - Make initializing optional (first run creation of database)
 - Allow the initialization to run with 'nice'
 - Support multiple report_url configurations
 - Rename variables to map to the AIDE config file values
 - Add parameter validation
 - Syntax fixups
 - Remove the cron resources. It was not flexible enough to make sense here, imo

## mklauber/aide-1.1.0

 - Refactored the aide::watch type to accept a `type` param instead of the `excludes` param.  
    - This provided support for 'equals' directory specifications.

## mklauber/aide-1.0.0

 - Support for Debian based OS's
 - Support for Redhat based Os's
