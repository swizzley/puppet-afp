require 'spec_helper'

describe 'timecapsule', :type => 'class' do

  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end

    it {
      should contain_package('netatalk').with( { 'name' => 'netatalk' } )
      should contain_service('netatalk').with( { 'name' => 'netatalk' } )
      should contain_package('avahi').with( { 'name' => 'avahi' } )
      should contain_service('avahi-daemon').with( { 'name' => 'avahi-daemon' } )
      should contain_package('nss-mdns').with( { 'name' => 'nss-mdns' } )
      should contain_service('messagebus').with( { 'name' => 'messagebus' } )
      should contain_package('dbus').with( { 'name' => 'dbus' } )
    }
  end

  context "On an unknown OS" do
    let :facts do
      {
        :osfamily => 'Darwin'
      }
    end

    it {
      expect { should raise_error(Puppet::Error) }
    }
  end
