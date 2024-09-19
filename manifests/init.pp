#
# = Class: opendkim
#
# This class sets up opendkim
class opendkim (
  $ensure                       = present,
  $package                      = $::opendkim::params::package,
  $version                      = undef,
  $service                      = $::opendkim::params::service,
  $status                       = 'enabled',
  $file_mode                    = $::opendkim::params::file_mode,
  $file_owner                   = $::opendkim::params::file_owner,
  $file_group                   = $::opendkim::params::file_group,
  $file_opendkimconf            = $::opendkim::params::file_opendkimconf,
  $template_opendkimconf        = $::opendkim::params::template_opendkimconf,
  $file_keyTable                = $::opendkim::params::file_keyTable,
  $template_keyTable            = $::opendkim::params::template_keyTable,
  $keys                         = [],
  $file_signingTable            = $::opendkim::params::file_signingTable,
  $template_signingTable        = $::opendkim::params::template_signingTable,
  $signingtable                 = [],
  $file_trustedHosts            = $::opendkim::params::file_trustedHosts,
  $template_trustedHosts        = $::opendkim::params::template_trustedHosts,
  $mode                         = 'v',
  $canonicalization             = 'relaxed/relaxed',
  $domain                       = 'example.com',
  $selector                     = 'default',
  $minimumkeybits               = '1024',
  $keyfile                      = '/etc/opendkim/keys/default.private',
  $trustedhosts                 = [],
  $my_class                     = undef,
  $noops                        = undef,
  ) inherits opendkim::params {  

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $service_enable = $status ? {
      'enabled'     => true,
      'disabled'    => false,
      'running'     => undef,
      'stopped'     => undef,
      'activated'   => true,
      'deactivated' => false,
      'unmanaged'   => undef,
    }
    $service_ensure = $status ? {
      'enabled'     => 'running',
      'disabled'    => 'stopped',
      'running'     => 'running',
      'stopped'     => 'stopped',
      'activated'   => undef,
      'deactivated' => undef,
      'unmanaged'   => undef,
    }
    $file_ensure = present
  } else {
    $package_ensure = 'absent'
    $service_enable = undef
    $service_ensure = stopped
    $file_ensure    = absent
  }

  ### Extra classes
  if $my_class  { include $my_class }

  package { 'opendkim':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  service { 'opendkim':
    ensure  => $service_ensure,
    name    => $service,
    enable  => $service_enable,
    require => Package['postfix'],
    noop    => $noops,
  }

  # set defaults for file resource in this scope.
  File {
    ensure  => $file_ensure,
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    notify  => Service['opendkim'],
    require => Package['opendkim'],
    noop    => $noops,
  }

  file { '/etc/opendkim.conf':
    owner   => root,
    group   => root, 
    mode    => '0644',
    path    => $file_opendkimconf,
    content => template($template_opendkimconf),
  }

  file { '/etc/opendkim/KeyTable':
    path    => $file_keyTable,
    content => template($template_keyTable),
  }

  file { '/etc/opendkim/SigningTable':
    path    => $file_signingTable,
    content => template($template_signingTable),
  }

  file { '/etc/opendkim/TrustedHosts':
    path    => $file_trustedHosts,
    content => template($template_trustedHosts),
  }

}
# vi:syntax=puppet:filetype=puppet:ts=4:et:nowrap:
