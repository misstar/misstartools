#!/bin/sh
clear
echo "Thank you for install Misstar Tools For MiRouter!"


## Check The Router Hardware Model 
mode=$(cat /proc/xiaoqiang/model)

if [ "$mode" = "R2D" -o "$mode" = "R1D" ];then
	Hardware_model="arm"
elif [ "$mode" = "R3" ];then
	Hardware_model="mips"
else
	echo "This Tools doesn't support XiaoMi Mini"
	exit
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
