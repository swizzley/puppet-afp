# Class: afp::params
#
# This module manages afp
#
# @param volume
# @param mount
# The variables which can be used for substitutions are:
#
# $b
# basename
#
# $c
# client's ip or appletalk address
#
# $d
# volume pathname on server
#
# $f
# full name (contents of the gecos field in the passwd file)
#
# $g
# group name
#
# $h
# hostname
#
# $i
# client's ip, without port
#
# $s
# server name (this can be the hostname)
#
# $u
# user name (if guest, it is the user that guest is running as)
#
# $v
# volume name (either ADEID_NAME or basename of path)
#
# $z
# appletalk zone (may not exist)
#

class afp::params (
  $ports        = $::afp::config::ports,
  $services     = $::afp::config::services,
  $avahi_ssh    = $::afp::config::avahi_ssh,
  $afpd         = $::afp::config::afpd,
  $package      = $::afp::config::package,
  $netatalk_url = $::afp::config::netatalk_url) inherits afp::config {
  $user = 'afp'
  $password = '5XjeYxRW0bohs' # this equals "afp"
  $manage_user = true
  $group = 'afp'
  $manage_group = true
  $enable_avahi_ssh = false
  $use_iptables = true
  $use_epel = true
  $epel7 = 'https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'
  $epel_gpgcheck = true

  # comment out & or modify the volumes hash below as you wish.
  # these are intended only to be working examples
  $volumes = {
    'mnt'    => {
      volume => '/mnt',
      name   => 'Mountdir',
    }
    ,
    'users'  => {
      volume => '/home/$u',
      name   => 'Homedir for $u',
    }
    ,
    'groups' => {
      volume => '/home/$g',
      name   => 'Groupdir for $g',
    }
    ,
    'home'   => {
      volume => '/home',
      name   => 'Homedir',
    }
    ,
  }

  # This is only needed if you are using the groups dir in the hash above
  if $volumes['groups'] {
    file { "/home/${group}":
      ensure => directory,
      owner  => root,
      group  => $group,
      mode   => '0770',
    }
  }

  afp::volumes { 'Appletalk_shares': shared => $volumes }

}
