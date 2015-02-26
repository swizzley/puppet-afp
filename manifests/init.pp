# Class: afp
#
# This module manages afp
#
# License: Apache-2.0 License
#
# Author: Dustin Morgan <morgan@aspendenver.org>
#
# @example include afp
# @param user
# @param pass
# @param group
# @param mount
#

class afp (
  $repo         = $::afp::params::epel7,
  $user         = $::afp::params::user,
  $pass         = $::afp::params::password,
  $group        = $::afp::params::group,
  $package      = $::afp::params::package,
  $ports        = $::afp::params::ports,
  $services     = $::afp::params::services,
  $avahi_ssh    = $::afp::params::avahi_ssh,
  $install_epel = $::afp::params::use_epel,
  $gpgcheck     = $::afp::params::epel_gpgcheck,
  $firewall     = $::afp::params::use_iptables,
  $bonjour_ssh  = $::afp::params::enable_avahi_ssh,
  $manage_user  = $::afp::params::manage_user,
  $manage_group = $::afp::params::manage_group,
  $afpd         = $::afp::params::afpd,
  $netatalk_url = $::afp::params::netatalk_url) inherits afp::params {
  validate_bool($install_epel)
  validate_bool($firewall)
  validate_bool($bonjour_ssh)
  validate_bool($manage_user)
  validate_bool($manage_group)
  validate_bool($gpgcheck)

  define volumes ($shared = undef) {
    file { '/etc/netatalk/AppleVolumes.default':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('afp/AppleVolumes.default.erb'),
      require => Package['netatalk'],
      notify  => Service['netatalk'],
    }
  }

  case $::osfamily {
    'RedHat' : {
      if $install_epel {
        if $::operatingsystemmajrelease == '7' {
          if $::operatingsystem != 'Fedora' {
            exec { 'get netatalk package from rpmfind ftp':
              path    => '/usr/bin',
              command => "yum install -y ${netatalk_url}",
              unless  => 'test -f /usr/sbin/afpd',
            }
          }
        }
        yumrepo { 'epel':
          descr          => "Extra Packages for Enterprise Linux ${::operatingsystemmajrelease} - ${architecture}",
          mirrorlist     => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::operatingsystemmajrelease}&arch=${architecture}",
          baseurl        => absent,
          failovermethod => 'priority',
          enabled        => true,
          gpgcheck       => $gpgcheck,
          gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
        } ->
        file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::operatingsystemmajreleasee}":
          ensure => present,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => "puppet:///modules/epel/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
        } ->
        exec { 'install EPEL 7 repo':
          path    => '/bin',
          command => "rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::operatingsystemmajreleasee}",
          unless  => 'test -f /etc/yum.repos.d/epel.repo',
        }
      }

      package { $package: ensure => installed } ->
      service { $services:
        ensure => 'running',
        enable => true,
      }

      file { '/etc/netatalk/afpd.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => $afpd,
        require => Package['netatalk'],
        notify  => Service['netatalk'],
      }

      file { '/etc/avahi/services/afpd.service':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('afp/afpd.service.erb'),
        require => Package['avahi'],
        notify  => Service['avahi-daemon'],
      }

      exec { 'nsswitch switch':
        path    => '/usr/bin',
        command => 'cp /etc/nsswitch.conf /etc/nsswitch.conf.pre-afp && sed -i "/^hosts:/c\hosts:      files mdns4_minimal dns mdns mdns4" /etc/nsswitch.conf',
        unless  => 'test -f /etc/nsswitch.conf.pre-afp',
      }

      if $bonjour_ssh {
        file { $avahi_ssh:
          ensure => present,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
        }
      } else {
        file { $avahi_ssh: ensure => absent, }
      }

      if $firewall {
        firewall { '000 accept all afp':
          port   => $ports,
          proto  => ['tcp', 'udp'],
          action => 'accept',
        }
      }

      if $manage_user {
        user { $user:
          ensure   => present,
          gid      => $group,
          password => $pass,
        }

        file { "/home/${user}":
          ensure => directory,
          owner  => $user,
          group  => $group,
          mode   => '0755',
        }
      }

      if $manage_group {
        group { $group: ensure => present, }
      }
    }
    default  : {
      fail("unsupported osfamily: $::osfamily")
    }
  }
}