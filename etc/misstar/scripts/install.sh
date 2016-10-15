#!/bin/sh
clear
echo "Thank you for install Misstar Tools For MiRouter!"


## Check The Router Hardware Model 
Hardware_ID=$(uname -a | grep arm | wc -l)
if [ "$Hardware_ID" = '0' ];then
	if [ $(uname -a | awk '{print $4;}' | sed 's/'#'//') = '2' ]; then
		echo "Error:Misstar Tools  temporarily does not support Xiaomi Mini Router!"
		exit
	fi
fi

if [ "$Hardware_ID" = '1' ];then
	echo "Your Router Model Is R1D/R2D"
	Hardware_model="arm"
else
	echo "Your Router Model Is R3"
	Hardware_model="mips"
fi 



echo "The installnation process will reboot your router after complete"

echo "Do you want to continue?"
echo -n "[Press any key to continue and CTRL+C to EXIT]:"

read continue


url="http://www.misstar.com/tools/"${Hardware_model}"/qixi"

wget ${url}/misstar.tar.gz -O /tmp/misstar.tar.gz

if [ $? -eq 0 ];then
    echo "DownLoad installnation package complete"
else 
    echo "Error:DownLoad installnation package Failed"
    exit
fi


mount -o remount,rw /

if [ $? -eq 0 ];then
    echo "Mount the filesystem to RW complete"
else 
    echo "Error:Mount the filesystem to RW  Failed"
    exit
fi


sed -i '/misstar/d' /usr/lib/lua/luci/controller/web/index.lua
sed -i '/\"misstar\"/d' /usr/lib/lua/luci/view/web/inc/header.htm
sed -i '/misstar/,/end/d' /usr/lib/lua/luci/view/web/inc/header.htm
sed -i '/file_check/d' /etc/firewall.user
rm -rf /usr/lib/lua/luci/controller/api/misstar.lua
rm -rf /etc/comfig/ss-redir
rm -rf /etc/misstar


mkdir /etc/misstar

tar -zxvf /tmp/misstar.tar.gz -C /


if [ $? -eq 0 ];then
    echo "Uncompress package complete"
else 
    echo "Error:Uncompress package Failed"
    exit
fi

echo "Copy file to the destination directory..."



chmod +x /etc/misstar/$Hardware_model/*

chmod +x /etc/misstar/scripts/*


cd /etc/misstar/scripts


cp -rf /etc/misstar/.config/misstar /etc/config/misstar

echo "Copy file to the destination directory   DONE"



chmod 777 /etc/firewall.user


if [ $(cat /etc/firewall.user | grep 'file_check.sh' | wc -l) == '0' ]; then
	echo "/etc/misstar/scripts/file_check.sh" >> /etc/firewall.user 
fi

if [ $? -eq 0 ];then
    echo -e "Misstar Tools install complete\n The System is restarting"
else 
    echo "Error:Misstar Tools install  Failed"
    exit
fi

/etc/misstar/scripts/file_check.sh

reboot
