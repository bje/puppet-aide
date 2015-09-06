# class for managing aide installation
class aide::package {
  package { 'aide':
    ensure => $::aide::version,
    name   => $::aide::package
  }
}
