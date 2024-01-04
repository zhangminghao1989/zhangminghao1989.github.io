#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "====================================="
echo "# A tool like htpasswd for Nginx    #"
echo "#-----------------------------------#"
echo "# Author:Licess http://www.lnmp.org #"
echo "====================================="

#set password

	unpassword=""
	read -p "Please input the Password:" unpassword
	if [ "$unpassword" = "" ]; then
		echo "Error:Password can't be NULL!"
		exit 1
	fi
password=$(perl -e 'print crypt($ARGV[0], "pwdsalt")' $unpassword)
	echo "==========================="
	echo "Password was: $password"
	echo "==========================="
