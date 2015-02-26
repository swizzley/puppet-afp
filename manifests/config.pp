# Class: afp::config
#
# This module manages afp
#

class afp::config (
  $package = $::afp::packages::package,
  $netatalk_url = $::afp::packages::netatalk_url,
)inherits afp::packages {
  $ports = ['548', '5354', '5353']
  $services = ['avahi-daemon', 'messagebus', 'netatalk']
  $avahi_ssh = '/etc/avahi/services/ssh.service'
  $afpd = ' - -tcp -noddp -uamlist uams_dhx_passwd.so,uams_dhx2_passwd.so'

}
