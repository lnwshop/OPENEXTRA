#!/bin/bash

# Check root
if [[ "$EUID" -ne 0 ]]; then
	echo ""
	echo "กรุณาเข้าสู่ระบบผู้ใช้ root ก่อนทำการติดตั้งสคริปท์"
	echo "คำสั่งเข้าสู่ระบบผู้ใช้ root คือ sudo -i"
	echo ""
fi

# Check OS can't run script
if [[ -e /etc/centos-release || -e /etc/redhat-release || -e /etc/system-release && ! -e /etc/fedora-release ]]; then
	OS=centos
	echo ""
	echo "ขณะนี้ OS $OS ยังไม่รอบรับกับสคริปท์นี้"
elif [[ -e /etc/arch-release ]]; then
	OS=arch
	echo ""
	echo "ขณะนี้ OS $OS ยังไม่รอบรับกับสคริปท์นี้"
elif [[ -e /etc/fedora-release ]]; then
	OS=fedora
	echo ""
	echo "ขณะนี้ OS $OS ยังไม่รอบรับกับสคริปท์นี้"
fi

# Set OS Version
OS="debian"
VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
IPTABLES='/etc/iptables/iptables.rules'
SYSCTL='/etc/sysctl.conf'

# Set your IP
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# Set Localtime GMT +7
ln -fs /usr/share/zoneinfo/Asia/Thailand /etc/localtime

clear

# Color
color1='\e[031;1m'
color3='\e[0m'

# Menu
echo ""
echo -e "${color1}  (\_(\  ${color3}"
echo -e "${color1} (=’ :’) :* ${color3} Script by Mnm Ami"
echo -e "${color1}  (,(”)(”) °.¸¸.• ${color3}"
echo ""
echo -e "FUNCTION SCRIPT ${color1}✿.｡.:* *.:｡✿*ﾟ’ﾟ･✿.｡.:*${color3}"
echo ""
echo -e "|${color1}1${color3}|  OPENVPN (TERMINAL CONTROL)"
echo -e "|${color1}2${color3}|  OPENVPN (PRITUNL CONTROL)"
echo -e "|${color1}3${color3}|  SSH + DROPBEAR"
echo -e "|${color1}4${color3}|  WEB PANEL"
echo -e "|${color1}5${color3}|  VNSTAT (CHECK BANDWIDTH or DATA)"
echo -e "|${color1}6${color3}|  SETUP ALL FUNCTION"
echo ""
read -p "กรุณาเลือกฟังก์ชั่นที่ต้องการติดตั้ง (ตัวเลข) : " Menu

case $Menu in

	1)
	echo "1 กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"
#	mkdir /root/backup
#	cp /etc/apt/sources.list /root/backup

	;;
	
	2)

	# Debian 8
	if [[ "$VERSION_ID" = 'VERSION_ID="8"' ]]; then

	echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.6 main" > /etc/apt/sources.list.d/mongodb-org-3.6.list
	echo "deb http://repo.pritunl.com/stable/apt jessie main" > /etc/apt/sources.list.d/pritunl.list
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
	sudo apt-get update
	sudo apt-get --assume-yes install pritunl mongodb-org
	sudo systemctl start mongod pritunl
	sudo systemctl enable mongod pritunl

		while [[ $CONTINUE != "Y" && $CONTINUE != "N" ]]; do

			echo ""
			echo "OS "
			echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
			read -p "ขอแนะนำให้ติดตั้ง (Y or N) : " -e -i Y CONTINUE

		done

			if [[ "$CONTINUE" = "N" ]]; then

			echo "ยังไม่ติดตั้ง 8"
			exit

			fi

	# Debian 9
	elif [[ "$VERSION_ID" = 'VERSION_ID="9"' ]]; then

	echo "deb http://repo.pritunl.com/stable/apt stretch main" > /etc/apt/sources.list.d/pritunl.list
	sudo apt-get -y install dirmngr
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
	sudo apt-get update
	sudo apt-get --assume-yes install pritunl mongodb-server
	sudo systemctl start mongodb pritunl
	sudo systemctl enable mongodb pritunl

		while [[ $CONTINUE != "Y" && $CONTINUE != "N" ]]; do

			echo ""
			echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
			read -p "ขอแนะนำให้ติดตั้ง (Y or N) : " -e -i Y CONTINUE

		done

			if [[ "$CONTINUE" = "N" ]]; then

			echo "ยังไม่ติดตั้ง 9"
			exit

			fi

	# Ubuntu 14.04
	elif [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then

	echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.6.list
	echo "deb http://repo.pritunl.com/stable/apt trusty main" > /etc/apt/sources.list.d/pritunl.list
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
	sudo apt-get update
	sudo apt-get --assume-yes install pritunl mongodb-org
	sudo service pritunl start

		while [[ $CONTINUE != "Y" && $CONTINUE != "N" ]]; do

			echo ""
			echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
			read -p "ขอแนะนำให้ติดตั้ง (Y or N) : " -e -i Y CONTINUE

		done

			if [[ "$CONTINUE" = "N" ]]; then

			echo "ยังไม่ติดตั้ง 14.04"
			exit

			fi

	# Ubuntu 16.04
	elif [[ "$VERSION_ID" = 'VERSION_ID="16.04"' ]]; then

#	echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.6.list
#	echo "deb http://repo.pritunl.com/stable/apt xenial main" > /etc/apt/sources.list.d/pritunl.list
#	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
#	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
#	sudo apt-get update
#	sudo apt-get --assume-yes install pritunl mongodb-org
#	sudo systemctl start pritunl mongod
#	sudo systemctl enable pritunl mongod

		while [[ $CONTINUE != "Y" && $CONTINUE != "N" ]]; do

			echo ""
			echo "คุณต้องการติดตั้ง Squid Proxy หรือไม่ ?"
			read -p "ขอแนะนำให้ติดตั้ง (Y or N) : " -e -i Y CONTINUE

		done

			if [[ "$CONTINUE" = "N" ]]; then

			echo "ยังไม่ติดตั้ง 16.04"
			exit

			fi

	fi

		# Install Squid
		if [[ "$VERSION_ID" != 'VERSION_ID="8"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="14.04"' ]]; then

apt-get -y install squid3
cat > /etc/squid3/squid.conf <<END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
coredump_dir /var/spool/squid3
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname openextra.net
END
sed -i $MYIP2 /etc/squid3/squid.conf;
/etc/init.d/squid restart
		fi

		if [[ "$VERSION_ID" != 'VERSION_ID="9"' ]] && [[ "$VERSION_ID" != 'VERSION_ID="16.04"' ]]; then

apt-get -y install squid
cat > /etc/squid/squid.conf <<END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localhost
http_access deny all
http_port 8080
coredump_dir /var/spool/squid
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern . 0 20% 4320
visible_hostname OPENEXTRA.NET
END
sed -i $MYIP2 /etc/squid/squid.conf;
/etc/init.d/squid restart

		fi

	;;
	
	
	3)
	echo "3 กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"
	;;

	4)
	echo "4 กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"
	;;
	
	5)
	echo "5 กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"
	# Install Vnstat
#	apt-get -y install vnstat
#	vnstat -u -i eth0
	
	# Install Vnstat GUI
	
#	rm /etc/apt/sources.list
#	cp /root/backup/sources.list /etc/apt/

	;;
	
	6)
	echo "6กรุณารอสักนิด ขณะนี้ยังไม่ได้ติดตั้งคำสั่งนี้"
	;;

esac
