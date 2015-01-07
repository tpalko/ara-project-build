## Requirements

* jdk1.6.0_45
	* You can get the JDK from anywhere, but it is included in this project. The share path in the Vagrantfile will need to reflect its location.
* android source
	* The android source must live on a journaled, case-sensitive partition.  Apple's HFS does not meet these requirements, and so a new disk image must be created, mounted on the host machine, and be available for sharing to the virtual machine.
* repo / git
	* repo and git are installed on the virtual machine by the 'ara' cookbook
* various package dependencies
	* installed on the virutal	 machine by the 'ara' cookbook
* various environment variable settings
	* installed on the virutal	 machine by the 'ara' cookbook
	
The development environment is structured to provide a true Linux platform for building, while allowing development on any platform that supports VirtualBox (and vagrant).

The Linux platform is not absolutely necessary, however most build instructions expect Linux, and it circumvents many complications in compiling the android source.  

To accomplish the desired development environment, the JDK and android source must exist on the host machine and be shared to the virtual machine.

## Instructions

 1. Create a journaled, case-sensitive disk image >= 60 GB  
The configuration in _this_ project assumes this is located at:

		/usr/local/src/projectara.dmg

	and mounted at:

		/Volumes/ara
	
	but this can sit wherever you want as long as the Vagrantfile is modified accordingly.

2. Obtain Java JDK 1.6  
The configuration in _this_ project assumes this is located at:

		/usr/local/src/jdk1.6.0_45

	but this can sit wherever you want as long as the Vagrantfile is modified accordingly.

3. Review the Vagrantfile to meet your system specification.  Specifically, the memory allocation, number of CPU cores, location of shared folders, and the name of the Vagrant box. 

	** Note: the 'ara' cookbook specifically installs packages necessary for Android builds on Ubuntu 14.04. Other distributions may require different packages. **

4. Run these commands:

	** Note: These work best if you read through before running. There are some values you may want to change. **

		$ vagrant up
		$ vagrant ssh
		$ git config --global user.name "Your Full Name Here"
		$ git config --global user.email "your-email@example.com"
	
		$ cd ~/android_source
	
	This section is a candidate for inclusion/automation in the 'ara' cookbook.. the bash logon script could set these environment variables, init the repository, and even pull the source:
	
		$ export MFST_REPO=https://ara-mdk.googlesource.com/manifest
		$ export MFST_BRANCH=master
		$ export MFST_FILE=google-ara-dev.xml
		$ export REPO_GROUPS=common,ara-dev
	
		$ repo init -u $MFST_REPO -b $MFST_BRANCH -m $MFST_FILE -g $REPO_GROUPS
	
		$ repo sync
	
		$ export CDPATH=
		$ export TARGET_PRODUCT=pandaboard
		$ export TARGET_TOOLS_PREFIX=prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.7/bin/arm-linux-androideabi-
	
	This part, however, should probably just be run manually to keep an eye on its progress:
		
		$ cd ~/android_source
		$ . build/envsetup.sh	
		$ make -j8 boottarball systemtarball userdatatarball