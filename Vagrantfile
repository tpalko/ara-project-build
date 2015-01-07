# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # - any vagrantized Ubuntu 14.04 distribution
  config.vm.box = "vagrant-ubuntu1404"

  # - jdk1.6.0_45 can be found in root of this project
  config.vm.synced_folder "/usr/local/src/jdk1.6.0_45", "/home/vagrant/jdk1.6.0_45"

  # - this is the journaled, case-sensitive disk image that must be created specifically to hold the android source
  # - here is a convenience script that can be included in your shell configuration to mount this image:
  # - function mountAra { hdiutil attach /usr/local/src/projectara.dmg -mountpoint /Volumes/ara; }
  # - the image must be mounted prior to vagrant up
  config.vm.synced_folder "/Volumes/ara", "/home/vagrant/android_source"

  config.vm.provider "virtualbox" do |vb|
    
    # - as many GB * 1024 as you can muster
    vb.memory = 14*1024
    
    # - all your core are belong to us 
    # - VirtualBox will default to one (1) core, but the android source build accepts a parameter for multi-core compilation, so use it
    vb.cpus = 8

  end

  config.vm.provision "chef_solo" do |chef|
      chef.add_recipe "apt"
      chef.add_recipe "ara"
  end

end
