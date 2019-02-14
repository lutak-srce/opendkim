#
# = Class: opendkim::params
#
# This module contains defaults for opendkim modules
#
class opendkim::params {

  $ensure           = 'present'
  $version          = undef
  $status           = 'enabled'
  $file_mode        = '0640'
  $file_owner       = 'opendkim'
  $file_group       = 'opendkim'
  $autorestart      = true
  $dependency_class = 'opendkim::dependency'
  $my_class         = undef

  # install package depending on major version
  case $::osfamily {
    default: {}
    /(RedHat|redhat|amazon)/: {
      $package               = 'opendkim'
      $service               = 'opendkim'
      $file_opendkimconf     = '/etc/opendkim.conf'
      $template_opendkimconf = 'opendkim/opendkim.conf.erb'
      $file_keyTable         = '/etc/opendkim/KeyTable'
      $template_keyTable     = 'opendkim/KeyTable.erb'
      $file_signingTable     = '/etc/opendkim/SigningTable'
      $template_signingTable = 'opendkim/SigningTable.erb'
      $file_trustedHosts     = '/etc/opendkim/TrustedHosts'
      $template_trustedHosts = 'opendkim/TrustedHosts.erb'
    }
  }

}
