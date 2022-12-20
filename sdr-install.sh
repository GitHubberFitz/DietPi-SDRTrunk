#!/bin/bash
xarch=$(getconf LONG_BIT)
if [ "$xarch" == "32" ]; then
    echo "32"
	mkdir -p /root/downloads/java/
	wget https://download.bell-sw.com/java/17.0.5+8/bellsoft-jdk17.0.5+8-linux-arm32-vfp-hflt-full.deb -P /root/downloads/java/
	apt install /root/downloads/java/*.deb -y	
	
	if [[ ! -f /etc/profile.bak ]]; then
		cp /etc/profile /etc/profile.bak
		echo '' >> /etc/profile
		echo 'export PATH_BAK=$PATH' >> /etc/profile
		echo 'export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-arm32-vfp-hflt"' >> /etc/profile
		echo 'export PATH=$JAVA_HOME/bin:$PATH_BAK' >> /etc/profile
	fi

	if [[ ! -z "${PATH_BAK}" ]]; then
	  	export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-arm32-vfp-hflt"
		export PATH=$JAVA_HOME/bin:$PATH_BAK
	else
	  	export PATH_BAK=$PATH
		export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-arm32-vfp-hflt"
		export PATH=$JAVA_HOME/bin:$PATH_BAK
	fi

	### Install SDR Drivers
	if [ "$(which rtl_sdr)" != ""]
		apt install rtl-sdr -y
	fi

	### SDRTrunk
	if [[ ! -f /root/downloads/sdrtrunk ]]; then
		rm -rf /root/downloads/sdrtrunk
	fi
	git clone https://github.com/DSheirer/sdrtrunk.git /root/downloads/sdrtrunk
	sed -i "s/^version.*/version = '0.5.0-beta6'/g" /root/downloads/sdrtrunk/build.gradle
	#sed -i "s/^version =.*/version = '0.4.0'/g" /root/downloads/sdrtrunk/build.gradle
	sed -i "s/^sourceCompatibility =.*/sourceCompatibility = '17'/g" /root/downloads/sdrtrunk/build.gradle
	/root/downloads/sdrtrunk/gradlew clean build -p /root/downloads/sdrtrunk/

	if [[ ! -f /root/downloads/sdrtrunk/build/distributions/sdr-trunk*.zip ]]; then
		if [[ ! -f /root/sdr-trunk ]]; then
			rm -rf /root/sdr-trunk
		fi
		unzip /root/downloads/sdrtrunk/build/distributions/sdr-trunk*.zip -d /root/
		mv /root/sdr-trunk* /root/sdr-trunk
	fi

	### Run SDR for DIR creation
	#rm -rf /root/SDRTrunk/
	#/root/sdr-trunk/bin/sdr-trunk
	#/root/sdr-trunk/bin/sdr-trunk &
	sleep 15
	killall java

	mv /root/SDRTrunk/playlist/default.xml /root/SDRTrunk/playlist/default.xml.bak

	### Build JMBE
	if [[ ! -f /root/downloads/jmbe ]]; then
		rm -rf /root/downloads/jmbe
	fi
	git clone https://github.com/DSheirer/jmbe.git /root/downloads/jmbe
	/root/downloads/sdrtrunk/gradlew build -p /root/downloads/jmbe/
	
	/root/downloads/jmbe/codec/build/libs/jmbe-1.0.9.jar

	### Autostart
	check=$( grep "sdr" /etc/xdg/lxsession/LXDE/autostart )
	if [ ! -n "$check" ]; then
		echo "/root/sdr-trunk/bin/sdr-trunk" >> /etc/xdg/lxsession/LXDE/autostart
	fi


	### Other
	dietpi-software install 200
	sed -i "s/^pass =.*/pass = false/g" /opt/dietpi-dashboard/config.toml
	service dietpi-dashboard restart

	### VNC
	dietpi-software install 28
	
	### JDK
	dietpi-software install 8
	
elif [ "$xarch" == "64" ]; then
	echo "64"
		mkdir -p /root/downloads/java/
	wget https://download.bell-sw.com/java/17.0.5+8/bellsoft-jdk17.0.5+8-linux-aarch64-full.deb -P /root/downloads/java/
	apt install /root/downloads/java/*.deb -y
	
	if [[ ! -f /etc/profile.bak ]]; then
		cp /etc/profile /etc/profile.bak
		echo '' >> /etc/profile
		echo 'export PATH_BAK=$PATH' >> /etc/profile
		echo 'export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-aarch64"' >> /etc/profile
		echo 'export PATH=$JAVA_HOME/bin:$PATH_BAK' >> /etc/profile
	fi

	if [[ ! -z "${PATH_BAK}" ]]; then
	  	export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-aarch64"
		export PATH=$JAVA_HOME/bin:$PATH_BAK
	else
	  	export PATH_BAK=$PATH
		export JAVA_HOME="/usr/lib/jvm/bellsoft-java17-full-aarch64"
		export PATH=$JAVA_HOME/bin:$PATH_BAK
	fi

	### Install SDR Drivers
	if [ "$(which rtl_sdr)" != ""]
		apt install rtl-sdr -y
	fi

	### SDRTrunk
	if [[ ! -f /root/downloads/sdrtrunk ]]; then
		rm -rf /root/downloads/sdrtrunk
	fi
	git clone https://github.com/DSheirer/sdrtrunk.git /root/downloads/sdrtrunk
	sed -i "s/^version.*/version = '0.5.0-beta6'/g" /root/downloads/sdrtrunk/build.gradle
	#sed -i "s/^version =.*/version = '0.4.0'/g" /root/downloads/sdrtrunk/build.gradle
	sed -i "s/^sourceCompatibility =.*/sourceCompatibility = '17'/g" /root/downloads/sdrtrunk/build.gradle
	/root/downloads/sdrtrunk/gradlew clean build -p /root/downloads/sdrtrunk/

	if [[ ! -f /root/downloads/sdrtrunk/build/distributions/sdr-trunk*.zip ]]; then
		if [[ ! -f /root/sdr-trunk ]]; then
			rm -rf /root/sdr-trunk
		fi
		unzip /root/downloads/sdrtrunk/build/distributions/sdr-trunk*.zip -d /root/
		mv /root/sdr-trunk* /root/sdr-trunk
	fi

	### Run SDR for DIR creation
	#rm -rf /root/SDRTrunk/
	#/root/sdr-trunk/bin/sdr-trunk
	/root/sdr-trunk/bin/sdr-trunk &
	sleep 15
	killall java

	mv /root/SDRTrunk/playlist/default.xml /root/SDRTrunk/playlist/default.xml.bak


	### Build JMBE
	if [[ ! -f /root/downloads/jmbe ]]; then
		rm -rf /root/downloads/jmbe
	fi
	git clone https://github.com/DSheirer/jmbe.git /root/downloads/jmbe
	/root/downloads/sdrtrunk/gradlew build -p /root/downloads/jmbe/
	
	#/root/downloads/jmbe/codec/build/libs/jmbe-1.0.9.jar


	### Autostart
	check=$( grep "sdr" /etc/xdg/lxsession/LXDE/autostart )
	if [ ! -n "$check" ]; then
		echo "/root/sdr-trunk/bin/sdr-trunk" >> /etc/xdg/lxsession/LXDE/autostart
	fi


	### Other
	dietpi-software install 200
	sed -i "s/^pass =.*/pass = false/g" /opt/dietpi-dashboard/config.toml
	service dietpi-dashboard restart

	### VNC
	#dietpi-software install 28
	
	### JDK
	#dietpi-software install 8
	
else
    echo "Architechture not supported"
fi
