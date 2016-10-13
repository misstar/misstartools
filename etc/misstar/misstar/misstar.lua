module("luci.controller.api.misstar", package.seeall)



function index()
    local page   = node("api","misstar")
    page.target  = firstchild()
    page.title   = ("")
    page.order   = 100
    page.sysauth = "admin"
    page.sysauth_authenticator = "jsonauth"
    page.index = true
    entry({"api", "misstar", "ss"}, call("ssInfo"), (""), 401)
    entry({"api", "misstar", "ss_status"}, call("ssStatus"), (""), 402)
    entry({"api", "misstar", "ss_switch"}, call("ssSwitch"), (""), 403)
    entry({"api", "misstar", "set_ss"}, call("setSs"), (""), 404)
    entry({"api", "misstar", "del_ss"}, call("delSs"), (""), 405)
    entry({"api", "misstar", "set_ssauto"}, call("setSsAuto"), (""), 406)
    entry({"api", "misstar", "update"}, call("mis_update"), (""), 407)
    entry({"api", "misstar", "uninstall"}, call("mis_uninstall"), (""), 408)
    
    entry({"api", "misstar", "save_ss"}, call("save_ss"), (""), 409)
    
    
    entry({"api", "misstar", "get_ss"}, call("get_ss"), (""), 410)
    entry({"api", "misstar", "set_ssdns"}, call("set_ssdns"), (""), 411)
    entry({"api", "misstar", "get_ssstatus"}, call("get_ssstatus"), (""), 412)
    
    entry({"api", "misstar", "get_adm"}, call("get_adm"), (""), 420)
    entry({"api", "misstar", "set_adm"}, call("set_adm"), (""), 421)
    
    entry({"api", "misstar", "get_rm"}, call("get_rm"), (""), 430)
    entry({"api", "misstar", "set_rm"}, call("set_rm"), (""), 431)
    
    entry({"api", "misstar", "get_ftp"}, call("get_ftp"), (""), 440)
    entry({"api", "misstar", "set_ftp"}, call("set_ftp"), (""), 441)
    
    entry({"api", "misstar", "get_webshell"}, call("get_webshell"), (""), 450)
    entry({"api", "misstar", "set_webshell"}, call("set_webshell"), (""), 451)
    
    entry({"api", "misstar", "get_aria2"}, call("get_aria2"), (""), 460)
    entry({"api", "misstar", "set_aria2"}, call("set_aria2"), (""), 461)
    
    entry({"api", "misstar", "get_status"}, call("get_status"), (""), 491)
    
end

local LuciHttp = require("luci.http")
local XQConfigs = require("xiaoqiang.common.XQConfigs")
local XQSysUtil = require("xiaoqiang.util.XQSysUtil")
local XQErrorUtil = require("xiaoqiang.util.XQErrorUtil")
local uci = require("luci.model.uci").cursor()
local LuciUtil = require("luci.util")

function ssInfo()
    local result = {}
    local list = getSSList()
    local current = getSSInfo("interface")
    result["code"] = 0
    result["current"] = current
    result["list"] = list
    LuciHttp.write_json(result)
end

function getSSInfo(interface)
    local info = {
        proto = "",
        server = "",
        username = "",
        password = "",
        auto = "0",
        id = ""
    }
    local ss = uci:get("ss-redir","misstar","ss_server_name")
    local auto = uci:get("ss-redir","misstar","auto")
    if ss then
        info.id = ss
        info.auto=auto
    end
    return info
end


function getSSList()
    local result = {}
    uci:foreach("ss-redir", "interface",
        function(s)
            local item = {
                ["ss_server"] = s.ss_server,
                ["ss_server_port"] = s.ss_server_port,
                ["ss_password"] = s.ss_password,
                ["ss_method"] = s.ss_method,
                ["id"] = s.id
            }
            table.insert(result, item)
            -- result[s.id] = item
        end
    )
    return result
end



function setSs()
    local code = 0
    local result = {}
    local ss_server = LuciHttp.formvalue("ss_server")
    local ss_server_port = LuciHttp.formvalue("ss_server_port")
    local ss_password = LuciHttp.formvalue("ss_password")
    local ss_method = LuciHttp.formvalue("ss_method")
    local auto = LuciHttp.formvalue("auto")
    local id = LuciHttp.formvalue("id")
    local set = true
    local XQCryptoUtil = require("xiaoqiang.util.XQCryptoUtil")
    if id then
    	uci:delete("ss-redir", id)
    	local id = XQCryptoUtil.md5Str(ss_server)
    	LuciUtil.exec("uci set ss-redir." ..id.. "=interface >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server=" ..ss_server.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server_port=" ..ss_server_port.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_password=" ..ss_password.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_method=" ..ss_method.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".id=" ..id.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log")
    	set=true
    else
    	local id = XQCryptoUtil.md5Str(ss_server)
    	LuciUtil.exec("uci set ss-redir." ..id.. "=interface >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server=" ..ss_server.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server_port=" ..ss_server_port.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_password=" ..ss_password.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_method=" ..ss_method.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".id=" ..id.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log")
    	set=true
    end
    if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = XQErrorUtil.getErrorMessage(result.code)
    end
    LuciHttp.write_json(result)
end


function setSsAuto()
    local code = 0
    local result = {}
    local auto = LuciHttp.formvalue("auto")
    auto = tonumber(auto)
    if auto and auto == 1 then
        LuciUtil.exec("/etc/misstar/scripts/ss.sh enable")
    else
        LuciUtil.exec("/etc/misstar/scripts/ss.sh disable")
    end
	LuciUtil.exec("uci set ss-redir.misstar.auto=" ..auto)
    LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log") 
    result["code"] = code
    LuciHttp.write_json(result)
end

function delSs()
    local result = {}
    local id = LuciHttp.formvalue("id")
    uci:delete("ss-redir", id)
    uci:commit("ss-redir")
    result["code"] = 0
    LuciHttp.write_json(result)
end



-- status: 0 connected 1 connecting 2 failed 3 close 4 none
function ssStatus()
    local status = LuciUtil.exec("/etc/misstar/scripts/ss.sh status")
    os.execute("echo " ..status.. " >> /tmp/ss-redir.log")
    local result = {}
    result["status"]=status
    result["code"] = 0
    LuciHttp.write_json(result)
end



    
 function ssSwitch()
    local code = 0
    local result = {}
    local conn = tonumber(LuciHttp.formvalue("conn"))
    local id = LuciHttp.formvalue("id")
    local result = {}
    result["code"] = 1
    if conn and conn == 1 then
    	LuciUtil.exec("uci set ss-redir.misstar.ss_server_name=" ..id.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log")
        os.execute("/bin/rm /tmp/ss.stat.msg.last >/dev/null 2>/dev/null")
        os.execute("/etc/misstar/scripts/ss.sh stop")
        if os.execute("/etc/misstar/scripts/ss.sh start") == 0  then
        	result["code"] = 0
        end
    else
        os.execute("/bin/rm /tmp/ss.stat.msg.last >/dev/null 2>/dev/null")
        if os.execute("/etc/misstar/scripts/ss.sh stop") == 0 then 
        	result["code"] = 0
        end
    end
    LuciHttp.write_json(result)
end  


function mis_update()
    local result = {}
    local code=LuciUtil.exec("wget http://www.misstar.com/tools/update/update.sh -P /tmp/ >/dev/null 2>/dev/null && chmod +x /tmp/update.sh >/dev/null 2>/dev/null && /tmp/update.sh >/dev/null 2>/dev/null")
    result["code"] = code
    result["current"] = current
    result["list"] = list
    LuciHttp.write_json(result)
end

function mis_uninstall()
    local result = {}
    local code=LuciUtil.exec("/etc/misstar/scripts/uninstall.sh")
    result["code"] = code
    result["current"] = current
    result["list"] = list
    LuciHttp.write_json(result)
end


function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end



function save_ss()
    local code = 0
    local result = {}
    local ss_server = LuciHttp.formvalue("ss_server")
    local ss_server_port = LuciHttp.formvalue("ss_server_port")
    local ss_password = LuciHttp.formvalue("ss_password")
    local ss_method = LuciHttp.formvalue("ss_method")
    local ss_mode = LuciHttp.formvalue("ss_mode")
    local auto = LuciHttp.formvalue("auto")
    local id = LuciHttp.formvalue("id")
    local set = true
    local XQCryptoUtil = require("xiaoqiang.util.XQCryptoUtil")
    if id then
    	uci:delete("ss-redir", id)
    	local id = XQCryptoUtil.md5Str(ss_server)
    	LuciUtil.exec("uci set ss-redir." ..id.. "=interface >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server=" ..ss_server.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server_port=" ..ss_server_port.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_password=" ..ss_password.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_method=" ..ss_method.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".id=" ..id.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log")
    	set=true
    else
    	local id = XQCryptoUtil.md5Str(ss_server)
    	LuciUtil.exec("uci set ss-redir." ..id.. "=interface >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server=" ..ss_server.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci set ss-redir." ..id.. ".ss_server_port=" ..ss_server_port.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_password=" ..ss_password.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".ss_method=" ..ss_method.. " >> /tmp/ss-redir.log")
    	LuciUtil.exec("uci set ss-redir." ..id.. ".id=" ..id.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("uci commit ss-redir >> /tmp/ss-redir.log")
    	set=true
    end
    if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = XQErrorUtil.getErrorMessage(result.code)
    end
    LuciHttp.write_json(result)
end

function get_ss()
	local ss_info={}
	local dns_info={}
	local result = {}
	ss_info.ss_server = uci:get("misstar","ss","ss_server")
	ss_info.ss_local_port = uci:get("misstar","ss","ss_local_port")
	ss_info.ss_server_port = uci:get("misstar","ss","ss_server_port")
	ss_info.ss_mode = uci:get("misstar","ss","ss_mode")
	ss_info.ss_method = uci:get("misstar","ss","ss_method")
	ss_info.ss_passwd = uci:get("misstar","ss","ss_password")
	ss_info.enable = uci:get("misstar","ss","enable")
	
	dns_info.pac_no=LuciUtil.exec("cat /etc/misstar/.config/pac.conf  | grep server | awk -F '/' '{print $2}' | sed 's/^.//' | wc -l")
	dns_info.pac_list=LuciUtil.exec("cat /etc/misstar/.config/pac.conf  | grep server | awk -F '/' '{print $2}' | sed 's/^.//' ")
	
	dns_info.chn_no=LuciUtil.exec("cat /etc/misstar/.config/chnroute.txt | wc -l")
	dns_info.chn_list=LuciUtil.exec("cat /etc/misstar/.config/chnroute.txt  ")
	
	result["code"]=0
	result["ss_info"]=ss_info
	result["dns_info"]=dns_info
	LuciHttp.write_json(result)
end

function get_ssstatus()
	local ss_status={}
	local result = {}
	ss_status.ss_status=LuciUtil.exec("/etc/misstar/scripts/misstar ss status")
	ss_status.ss_dnsstatus=LuciUtil.exec("/etc/misstar/scripts/misstar ss dnsstatus")
	result["code"]=0
	result["ss_status"]=ss_status
	LuciHttp.write_json(result)
end


function set_ssdns()
	local code = 0
    local result = {}
    local ss_server = LuciHttp.formvalue("ss_server")
    local ss_server_port = LuciHttp.formvalue("ss_port")
    local ss_passwd = LuciHttp.formvalue("ss_passwd")
    local ss_method = LuciHttp.formvalue("ss_method")
    local ss_mode = LuciHttp.formvalue("ss_mode")
    local ss_enable = LuciHttp.formvalue("ss_enable")
    local ss_local_port = LuciHttp.formvalue("ss_local_port")
    local set = true
    
    LuciUtil.exec("uci set misstar.ss.enable=" ..ss_enable.. " >> /tmp/ss-redir.log")
	LuciUtil.exec("uci set misstar.ss.ss_server=" ..ss_server.. " >> /tmp/ss-redir.log")
    LuciUtil.exec("uci set misstar.ss.ss_server_port=" ..ss_server_port.. " >> /tmp/ss-redir.log")
    LuciUtil.exec("uci set misstar.ss.ss_password=" ..ss_passwd.. " >> /tmp/ss-redir.log")
    LuciUtil.exec("uci set misstar.ss.ss_method=" ..ss_method.. " >> /tmp/ss-redir.log")
    LuciUtil.exec("uci set misstar.ss.ss_local_port=" ..ss_local_port.. " >> /tmp/ss-redir.log")
    LuciUtil.exec("uci set misstar.ss.ss_mode=" ..ss_mode.. " >> /tmp/ss-redir.log")

	LuciUtil.exec("uci commit misstar >> /tmp/ss-redir.log")
	
	LuciUtil.exec("/etc/misstar/scripts/ss restart >> /tmp/ss-redir.log")
	
    set=true
    
    if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = XQErrorUtil.getErrorMessage(result.code)
    end
    LuciHttp.write_json(result)
end


function set_adm()
    local code = 0
    local result = {}
    local set=false
    local adm_enable_switch=LuciHttp.formvalue("adm_enable_switch")
    local adm_mode=LuciHttp.formvalue("adm_mode")
	LuciUtil.exec("uci set misstar.adm.enable=" ..adm_enable_switch.. "")
	LuciUtil.exec("uci set misstar.adm.mode=" ..adm_mode.. "")	
	LuciUtil.exec("uci commit misstar >> /tmp/ss-redir.log")
	LuciUtil.exec("/etc/misstar/scripts/adm restart >> /tmp/ss-redir.log")
	set=ture
	if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("adm_enable_switch")
    end
    LuciHttp.write_json(result)
end



function get_adm()
	local result = {}
	local adm_enable
	adm_enable = uci:get("misstar","adm","enable")
	adm_mode = uci:get("misstar","adm","mode")
	result["code"]=0
	result["adm_enable"]=adm_enable
	result["adm_mode"]=adm_mode
	LuciHttp.write_json(result)
end

function set_rm()
    local code = 0
    local result = {}
    local set=false
    local web_enable_switch=LuciHttp.formvalue("web_enable_switch")
    local sshd_enable_switch=LuciHttp.formvalue("sshd_enable_switch")
	LuciUtil.exec("uci set misstar.web.enable=" ..web_enable_switch.. "")
	LuciUtil.exec("uci set misstar.sshd.enable=" ..sshd_enable_switch.. "")
	LuciUtil.exec("uci commit misstar")
	LuciUtil.exec("echo " ..sshd_enable_switch..  " >> /tmp/ss-redir.log")
	if web_enable_switch then
		LuciUtil.exec("echo " ..sshd_enable_switch.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("/etc/misstar/scripts/misstar web enable")
	else
		LuciUtil.exec("echo " ..sshd_enable_switch.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("/etc/misstar/scripts/misstar web disable")
	end
	LuciUtil.exec("echo " ..sshd_enable_switch.. " >> /tmp/ss-redir.log")
	if sshd_enable_switch then
		LuciUtil.exec("echo " ..sshd_enable_switch.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("/etc/misstar/scripts/misstar sshd enable")
	else
		LuciUtil.exec("echo " ..sshd_enable_switch.. " >> /tmp/ss-redir.log")
		LuciUtil.exec("/etc/misstar/scripts/misstar sshd disable")
	end
	
	LuciUtil.exec("/etc/init.d/firewall restart")
	LuciUtil.exec("/etc/init.d/sysapihttpd restart")
	set=ture
	if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("rm_enable_switch")
    end
    LuciHttp.write_json(result)
end


function get_rm()
	local result = {}
	local web_enable
	local sshd_enable
	web_enable = uci:get("misstar","web","enable")
	sshd_enable = uci:get("misstar","sshd","enable")
	result["code"]=0
	result["web_enable"]=web_enable
	result["sshd_enable"]=sshd_enable
	LuciHttp.write_json(result)
end

function set_webshell()
    local code = 0
    local result = {}
    local set=false
    local webshell_enable_switch=LuciHttp.formvalue("webshell_enable_switch")
	LuciUtil.exec("uci set misstar.webshell.enable=" ..webshell_enable_switch)
	LuciUtil.exec("uci commit misstar >> /tmp/ss-redir.log")
	LuciUtil.exec("/etc/misstar/scripts/webshell restart >> /tmp/ss-redir.log")
	
	set=ture
	if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("webshell_enable_switch")
    end
    LuciHttp.write_json(result)
end



function get_webshell()
	local result = {}
	local webshell_enable
	webshell_enable = uci:get("misstar","webshell","enable")
	result["code"]=0
	result["webshell_enable"]=webshell_enable
	LuciHttp.write_json(result)
end

function set_ftp()
	local result = {}
	local enable
	local rm_enable
	local root_enable
	local any_enable
	local write_enable
	local ftp_user
	local ftp_password
	local user_path
	
    enable=LuciHttp.formvalue("enable")
    rm_enable=LuciHttp.formvalue("rm_enable")
    root_enable=LuciHttp.formvalue("root_enable")
    any_enable=LuciHttp.formvalue("any_enable")
    write_enable=LuciHttp.formvalue("write_enable")
    ftp_user=LuciHttp.formvalue("ftp_user")
    ftp_password=LuciHttp.formvalue("ftp_password")
    user_path=LuciHttp.formvalue("user_path")
    if enable then
		LuciUtil.exec("uci set misstar.vsftpd.enable=" ..enable)
		LuciUtil.exec("uci set misstar.vsftpd.rm_enable=" ..rm_enable)
		LuciUtil.exec("uci set misstar.vsftpd.root_enable=" ..root_enable)
		LuciUtil.exec("uci set misstar.vsftpd.any_enable=" ..any_enable)
		LuciUtil.exec("uci set misstar.vsftpd.write_enable=" ..write_enable)
		LuciUtil.exec("/etc/misstar/scripts/misstar vsftpd " ..ftp_user.. " " ..ftp_password.. " " ..user_path)
		LuciUtil.exec("uci commit misstar")
		LuciUtil.exec("/etc/misstar/scripts/vsftpd restart")
	else
		LuciUtil.exec("uci set misstar.vsftpd.enable=" ..enable)
		LuciUtil.exec("uci commit misstar")
		LuciUtil.exec("/etc/misstar/scripts/vsftpd stop")
	end

	set=ture
	if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("enable")
    end
    LuciHttp.write_json(result)
end



function get_ftp()
	local result = {}
	local enable
	local rm_enable
	local root_enable
	local any_enable
	local write_enable
	local ftp_user
	local user_path
	enable = uci:get("misstar","vsftpd","enable")
	rm_enable = uci:get("misstar","vsftpd","rm_enable")
	root_enable = uci:get("misstar","vsftpd","root_enable")
	any_enable = uci:get("misstar","vsftpd","any_enable")
	write_enable = uci:get("misstar","vsftpd","write_enable")
	ftp_user = uci:get("misstar","vsftpd","ftp_user")
	ftp_password = uci:get("misstar","vsftpd","ftp_password")
	user_path=LuciUtil.exec("cat /etc/passwd | grep "  ..ftp_user..  " | awk -F ':' '{print $6}'")
		
	result["code"]=0
	result["enable"]=enable
	result["rm_enable"]=rm_enable
	result["root_enable"]=root_enable
	result["any_enable"]=any_enable
	result["write_enable"]=write_enable
	result["ftp_user"]=ftp_user
	result["ftp_password"]=ftp_password
	result["user_path"]=user_path
	LuciHttp.write_json(result)
end




function set_aria2()
    local code = 0
    local result = {}
    local set=false
    local aria2_enable_switch=LuciHttp.formvalue("aria2_enable_switch")
    local user_path=LuciHttp.formvalue("user_path")
	LuciUtil.exec("uci set misstar.aria2.enable=" ..aria2_enable_switch.. "")
	LuciUtil.exec("uci set misstar.aria2.user_path=" ..user_path.. "")
	LuciUtil.exec("uci commit misstar >> /tmp/ss-redir.log")
	LuciUtil.exec("/etc/misstar/scripts/aria2 restart >> /tmp/ss-redir.log")
	set=ture
	if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    LuciHttp.write_json(result)
end



function get_aria2()
	local result = {}
	local adm_enable
	aria2_enable = uci:get("misstar","aria2","enable")
	user_path = uci:get("misstar","aria2","user_path")
	result["code"]=0
	result["aria2_enable"]=aria2_enable
	result["user_path"]=user_path
	LuciHttp.write_json(result)
end





function get_status()
	local result= {}
	local ss_status
	local adm_status
	local ftp_status
	local xlkn_status
	local web_status
	local ssh_status
	local aria2_status
	local webshell_status
	ss_status=LuciUtil.exec("ps | grep ss-redir | grep -v grep | wc -l")
	adm_status=LuciUtil.exec("ps | grep adm | grep -v grep | wc -l")
	ftp_status=LuciUtil.exec("ps | grep vsftp | grep -v grep | wc -l")
	web_status=uci:get("misstar","web","enable")
	ssh_status=uci:get("misstar","sshd","enable")
	webshell_status=LuciUtil.exec("ps | grep shellinabox | grep -v grep | wc -l")
	xlkn_status=0
	aria2_status=LuciUtil.exec("ps | grep aria2c | grep -v grep | wc -l")
	result["code"]=0
	result["ss_status"]=ss_status
	result["xlkn_status"]=xlkn_status
	result["adm_status"]=adm_status
	result["ftp_status"]=ftp_status
	result["web_status"]=web_status
	result["ssh_status"]=ssh_status
	result["aria2_status"]=aria2_status
	result["webshell_status"]=webshell_status

	LuciHttp.write_json(result)
end
