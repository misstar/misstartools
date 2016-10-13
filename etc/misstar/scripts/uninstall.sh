#!/bin/sh
mount -o remount,rw /
sed -i '/misstar/d' /usr/lib/lua/luci/controller/web/index.lua
sed -i '/\"misstar\"/d' /usr/lib/lua/luci/view/web/inc/header.htm
sed -i '/misstar/,/end/d' /usr/lib/lua/luci/view/web/inc/header.htm
sed -i '/file_check/d' /etc/firewall.user
sed -i '/misstar/d' /etc/crontabs/root
rm -rf /usr/lib/lua/luci/view/web/setting/misstar
rm -rf /usr/lib/lua/luci/view/web/inc/menu.htm
rm -rf /www/xiaoqiang/web/luci
rm -rf /etc/config/ss-redir
rm -rf /etc/config/misstar
rm -rf /etc/misstar
uci delete firewall.vsftpd
uci delete firewall.sshd
uci delete firewall.web

Hardware_ID=$(uname -a | grep arm | wc -l)
if [ "$Hardware_ID" = '0' ];then
	if [ $(uname -a | awk '{print $4;}' | sed 's/'#'//') = '2' ]; then
		echo "Error:Misstar Tools  temporarily does not support Xiaomi Mini Router!"
		exit
	fi
fi
if [ "$Hardware_ID" = '1' ];then
	Hardware_model="arm"
else
	Hardware_model="mips"
	rm /lib/libstdc\+\+.so
	rm /lib/libstdc\+\+.so.6
	ln -s /lib/libstdc\+\+.so.6.0.16 /lib/libstdc\+\+.so
	ln -s /lib/libstdc\+\+.so.6.0.16 /lib/libstdc\+\+.so.6
fi
reboot