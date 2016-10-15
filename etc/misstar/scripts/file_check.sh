#!/bin/sh


## Check The Router Hardware Model 
Hardware_ID=$(uname -a | grep arm | wc -l)
if [ "$Hardware_ID" = '1' ];then
	echo "Your Router Model Is R1D/R2D"
	Hardware_model="arm"
else
	echo "Your Router Model Is R1C/Mini/R3"
	Hardware_model="mips"
fi 


mount -o remount,rw /
ln -s /etc/misstar/misstar /usr/lib/lua/luci/view/web/setting/ >>  /tmp/ss-redir.log
ln -s /etc/misstar/misstar/menu.htm /usr/lib/lua/luci/view/web/inc/
ln -s /etc/misstar/luci /www/xiaoqiang/web/
ln -s /etc/misstar/misstar/misstar.lua /usr/lib/lua/luci/controller/api/



result=$(cat /etc/crontabs/root | grep Minjob | wc -l)

if [ "$result" == "0" ]; then

	echo "*/3 * * * * /etc/misstar/scripts/Minjob >/dev/null 2>&1" >> /etc/crontabs/root
	
fi

result=$(cat /etc/crontabs/root | grep Dayjob | wc -l)

if [ "$result" == "0" ]; then

	echo "0 4 * * * /etc/misstar/scripts/Dayjob >/dev/null 2>&1" >> /etc/crontabs/root
	
fi



result=$(cat /usr/lib/lua/luci/controller/web/index.lua | grep misstar | wc -l)

if [ "$result" == "0" ]; then
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"kddb\"}, template(\"web/setting/misstar/kddb\"), _(\"实用工具\"), 95)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"webshell\"}, template(\"web/setting/misstar/webshell\"), _(\"实用工具\"), 94)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"mzsm\"}, template(\"web/setting/misstar/mzsm\"), _(\"实用工具\"), 91)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"help\"}, template(\"web/setting/misstar/help\"), _(\"实用工具\"), 90)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"xlkn\"}, template(\"web/setting/misstar/xlkn\"), _(\"实用工具\"), 89)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"ftp\"}, template(\"web/setting/misstar/ftp\"), _(\"实用工具\"), 88)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"rm\"}, template(\"web/setting/misstar/rm\"), _(\"实用工具\"), 87)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"adm\"}, template(\"web/setting/misstar/adm\"), _(\"实用工具\"), 86)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"ss\"}, template(\"web/setting/misstar/ss\"), _(\"实用工具\"), 85)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"aria\"}, template(\"web/setting/misstar/aria\"), _(\"实用工具\"), 84)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"aria2\"}, template(\"web/setting/misstar/aria2\"), _(\"实用工具\"), 83)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"about\"}, template(\"web/setting/misstar/about\"), _(\"关于\"), 82)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\", \"index\"}, template(\"web/setting/misstar/index\"), _(\"实用工具\"), 81)" /usr/lib/lua/luci/controller/web/index.lua
	sed -i "/"topograph"/a\\  entry({\"web\", \"misstar\"}, alias(\"web\", \"misstar\", \"index\"), _(\"路由设置\"), 80)" /usr/lib/lua/luci/controller/web/index.lua
	echo "/etc/misstar/index.lua /usr/lib/lua/luci/controller/web/index.lua" >> /tmp/ss-redir.log

fi


result=$(cat /usr/lib/lua/luci/view/web/inc/header.htm | grep misstar | wc -l)

if [ "$result" == "0" ]; then

	result=$(grep -rn ' <li <%if string.find(REQUEST_URI, "/prosetting") then%>class="active"' /usr/lib/lua/luci/view/web/inc/header.htm | awk -F : '{print $1}')
	#result=`expr $result + 1`
	sed -i ""$result"a\\<li <%if string.find(REQUEST_URI, \"/misstar\") then%>class=\"active\"<%end%>><a href=\"<%=luci.dispatcher.build_url(\"web\",\"misstar\",\"index\")%>\"><%:百宝箱%></a></li>" /usr/lib/lua/luci/view/web/inc/header.htm
    echo "Add  /usr/lib/lua/luci/view/web/inc/header.htm" >> /tmp/ss-redir.log
	
fi
