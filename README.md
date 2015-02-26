# afp #

**Table of Contents**

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Presumptions](#presumptions)
    * [Credentials](#credentials)
4. [Usage](#usage)
    * [Server](#server)
    * [Client](#client)
    * [Considerations](#considerations)
5. [Requirements](#requirements)
6. [Compatibility](#compatibility)
7. [Limitations](#limitations)
8. [Development](#development)
    * [TODO](#todo)
    
## Overview ##

This is the afp module. It configures POSIX compatibility for the apple filing protocol "Appletalk" (afp://)


## Module Description ##

This module is derived from swizzley88-timecapsule to configure your linux host for mac file sharing. By default, if the user or group you're logged in as on your Mac exists on the afp server, a share will be available.

## Setup ##

You can configure the user, group, password, and as many shares as you want, so long as the absolute paths exist, and for the preconfigured user 'afp', it will.

```ruby
class timecapsule::params{
  
  $user = 'afp'
  $password = 'zo2Ps8mHNzFmY' #this equals "afp" 
  $group = 'afp'

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
}
```


#### Presumptions ####

1. You cannot use the swizzley88-timecapsule module in conjuction with this one.
2. You probably already have the same user on your Mac as on your afp server, in this case, configuration is taken care of by the $volume['users'] value. 

#### Credentials ####

Credentials are not required, but if you wish to require them, simply modify the AppleVolumes.default.erb options and reference http://netatalk.sourceforge.net/2.0/htmldocs/AppleVolumes.default.5.html for proper values and syntax
If you simply wish to use 'afp' you can connect from any capable OS using the preconfigured credentials. In order to set your default password hash to be managed, use the following command:
```bash
openssl passwd -crypt "secretPassword"
```


## Usage ##

#### Server ####
```ruby
include afp
```


#### Client ####

Open up finder and click the hostname of your server, click 'Connect As' from the upper right hand corner if your logged in user differs from $user


#### Considerations ####

If you use a spacewalk or satellite server for package management, or just plain don't want to enable the whole repo because you want to download and install the requirements manually for some reason, then just disable the $use_epel in params.

```ruby
class afp::params{
  $use_epel = true
}
```


## Requirements ##

puppetlabs/stdlib >= 4.2.0 

puppetlabs/firewall >= 1.1.3 


## Compatibility ##

  * RHEL 6, 7
  * CentOS 6, 7
  * Fedora 18, 19, 20, 21


## Limitations ##

This module has been tested on:

Server: 
  - Fedora 20
  - CentOS 7 

Client: 
  - OSX 10.10.2 (Yosemite)

This module should work on:

Server: 
  - Fedora 15, 16, 17, 18, 19, 21
  - CentOS 5, 6, 7 
  - RHEL Server 5, 6, 7
  - RHEL Client 7
  - RHEL Workstation 5, 6, 7 
	
Client: 
  - OSX 10.x
  - OS < 9.x (limited to 2GB volume reporting)
  - Windows (issues with name conventions)
  - *nix (with afp client enabled)
  - Dropbox (depricated)
	 
 
## Development ##

Any updates or contibutions are welcome.

Report any issues with current release, as any input will be considered valuable.


#### TODO ####

  * Add support for netatalk >= 3.0.0
  * Add Debian support
  * Add selinux support
 

###### Contact ######

Email:  morgan@aspendenver.org

WWW:    www.aspendenver.org

Github: https://github.com/swizzley


