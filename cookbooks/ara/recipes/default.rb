=begin
%w{ git gnupg flex bison gperf build-essential zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown libxml2-utils xsltproc zlib1g-dev:i386 }.each do |p|
	package p
end
=end

%w{ m4 git-core flex gperf automake texinfo bison zip }.each do |p|
	package p
end

%w{ build-essential }.each do |p|
	package p
end

bash "add _linary_repo" do
	user "root"
	code <<-EOH
	add-apt-repository ppa:linaro-maintainers/tools
	apt-get update
	apt-get install linaro-image-tools	
	EOH
	action :run
end

%w{ libc6:i386 libstdc++6:i386 zlib1g:i386 }.each do |p|
	package p
end

%w{ libswitch-perl u-boot-tools }.each do |p|
	package p
end

bash "symlink_libgl" do
	code <<-EOH
		sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
	EOH
	action :run
	not_if { ::File.exists?('/usr/lib/i386-linux-gnu/libGL.so') }
end

bash "configure_ccache" do
	user "vagrant"
	cwd "/home/vagrant/android_source"
	code <<-EOH 
		prebuilts/misc/linux-x86/ccache/ccache -M 50G
		echo "export USE_CCACHE=1" >> /home/vagrant/.bashrc
	EOH
	action :run
	not_if ("grep USE_CCACHE /home/vagrant/.bashrc")
end

bash "install_repo" do
	user "vagrant"
	code <<-EOH
		mkdir /home/vagrant/bin
		curl https://storage.googleapis.com/git-repo-downloads/repo > /home/vagrant/bin/repo
		chmod a+x /home/vagrant/bin/repo
	EOH
	action :run
	not_if { ::File.exists?('/home/vagrant/bin/repo') }
end

bash "set_path" do
	user "vagrant"
	code <<-EOH
		echo "export PATH=$PATH:/home/vagrant/jdk1.6.0_45/bin:/home/vagrant/bin:/home/vagrant/android_source/out/host/linux-x86/bin" >> /home/vagrant/.bashrc
	EOH
	action :run
	not_if ("grep android_source /home/vagrant/.bashrc")
end
