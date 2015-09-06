# class for managing aide installation
class aide::install {
  package { 'aide':
    ensure => $::aide::version,
    name   => $::aide::package
  }
}
