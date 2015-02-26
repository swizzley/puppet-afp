# Class: afp::packages
#
# This module manages afp
#

class afp::packages {
  $package = ['netatalk', 'avahi', 'dbus', 'nss-mdns']
  $netatalk_url = 'http://mirrors.maine.edu/Fedora/releases/20/Everything/x86_64/os/Packages/n/netatalk-2.2.3-9.fc20.x86_64.rpm'

}
