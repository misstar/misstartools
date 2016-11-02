module("luci.controller.api.misstar", package.seeall)



function index()
    local page   = node("api","misstar")
    page.target  = firstchild()
    page.title   = ("")
    page.order   = 100
    page.sysauth = "admin"
    page.sysauth_authenticator = "jsonauth"
    page.index = true

    entry({"api", "misstar", "update"}, call("mis_update"), (""), 607)
    entry({"api", "misstar", "uninstall"}, call("mis_uninstall"), (""), 608)    
    
    entry({"api", "misstar", "get_ss"}, call("get_ss"), (""), 610)
    entry({"api", "misstar", "set_ssdns"}, call("set_ssdns"), (""), 611)
    entry({"api", "misstar", "get_ssstatus"}, call("get_ssstatus"), (""), 612)
    entry({"api", "misstar", "add_pac"}, call("add_pac"), (""), 613)
    entry({"api", "misstar", "del_pac"}, call("del_pac"), (""), 614)
    entry({"api", "misstar", "add_white"}, call("add_white"), (""), 615)
    entry({"api", "misstar", "del_white"}, call("del_white"), (""), 616)

    
    entry({"api", "misstar", "get_adm"}, call("get_adm"), (""), 620)
    entry({"api", "misstar", "set_adm"}, call("set_adm"), (""), 621)
    entry({"api", "misstar", "get_kms"}, call("get_kms"), (""), 622)
    entry({"api", "misstar", "set_kms"}, call("set_kms"), (""), 623)
    
    
    entry({"api", "misstar", "get_rm"}, call("get_rm"), (""), 630)
    entry({"api", "misstar", "set_rm"}, call("set_rm"), (""), 631)
    
    entry({"api", "misstar", "get_ftp"}, call("get_ftp"), (""), 640)
    entry({"api", "misstar", "set_ftp"}, call("set_ftp"), (""), 641)
    
    entry({"api", "misstar", "get_webshell"}, call("get_webshell"), (""), 650)
    entry({"api", "misstar", "set_webshell"}, call("set_webshell"), (""), 651)
    
    
    
    entry({"api", "misstar", "get_aria2"}, call("get_aria2"), (""), 660)
    entry({"api", "misstar", "set_aria2"}, call("set_aria2"), (""), 661)
    
    
    
    
    entry({"api", "misstar", "get_status"}, call("get_status"), (""), 691)
    
end

local LuciHttp = require("luci.http")
local XQConfigs = require("xiaoqiang.common.XQConfigs")
local XQSysUtil = require("xiaoqiang.util.XQSysUtil")
local XQErrorUtil = require("xiaoqiang.util.XQErrorUtil")
local uci = require("luci.model.uci").cursor()
local LuciUtil = require("luci.util")


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



function get_ss()
	local ss_info={}
	local dns_info={}
	local result = {}
	ss_info.enable = uci:get("misstar","ss","enable")
	ss_info.ss_mode = uci:get("misstar","ss","ss_mode")
	ss_info.node_switch = uci:get("misstar","ss","node_switch")
	ss_info.dns_mode = uci:get("misstar","ss","dns_mode")
	
	ss_info.ss_server_1 = uci:get("misstar","ss","ss_server_1")
	ss_info.ss_local_port_1 = uci:get("misstar","ss","ss_local_port_1")
	ss_info.ss_server_port_1 = uci:get("misstar","ss","ss_server_port_1")
	ss_info.ss_method_1 = uci:get("misstar","ss","ss_method_1")
	ss_info.ss_passwd_1 = uci:get("misstar","ss","ss_password_1")
	ss_info.ssr_enable_1=uci:get("misstar","ss","ssr_enable_1")
	ss_info.ssr_protocol_1 = uci:get("misstar","ss","ssr_protocol_1")
	ss_info.ssr_obfs_1 = uci:get("misstar","ss","ssr_obfs_1")
	
	ss_info.ss_server_2 = uci:get("misstar","ss","ss_server_2")
	ss_info.ss_local_port_2 = uci:get("misstar","ss","ss_local_port_2")
	ss_info.ss_server_port_2 = uci:get("misstar","ss","ss_server_port_2")
	ss_info.ss_method_2 = uci:get("misstar","ss","ss_method_2")
	ss_info.ss_passwd_2 = uci:get("misstar","ss","ss_password_2")
	ss_info.ssr_enable_2=uci:get("misstar","ss","ssr_enable_2")
	ss_info.ssr_protocol_2 = uci:get("misstar","ss","ssr_protocol_2")
	ss_info.ssr_obfs_2 = uci:get("misstar","ss","ssr_obfs_2")
	
	dns_info.pac_no=LuciUtil.exec("cat /etc/misstar/.config/pac.conf  | grep server | awk -F '/' '{print $2}' | sed 's/^.//' | wc -l")
	
	dns_info.pac_no_customize=LuciUtil.exec("cat /etc/misstar/.config/pac_customize.conf | grep -v '^$' | wc -l")
	dns_info.pac_customize=LuciUtil.exec("cat /etc/misstar/.config/pac_customize.conf")

	dns_info.chn_no=LuciUtil.exec("cat /etc/misstar/.config/chnroute.txt | wc -l")
	
	dns_info.chn_no_customize=LuciUtil.exec("cat /etc/misstar/.config/chnroute_customize.txt | grep -v '^$' | wc -l")
	dns_info.chn_list=LuciUtil.exec("cat /etc/misstar/.config/chnroute_customize.txt")
	
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
	ss_status.ss_node=uci:get("misstar","ss","node")
	result["code"]=0
	result["ss_status"]=ss_status
	LuciHttp.write_json(result)
end


function set_ssdns()
	local code = 0
    local result = {}
    local ss_enable = LuciHttp.formvalue("ss_enable")
    local ss_mode = LuciHttp.formvalue("ss_mode")
    local node_switch = LuciHttp.formvalue("node_switch")
    local dns_mode = LuciHttp.formvalue("dns_mode")
    
    local ss_server_1 = LuciHttp.formvalue("ss_server_1")
    local ss_server_port_1 = LuciHttp.formvalue("ss_server_port_1")
    local ss_passwd_1 = LuciHttp.formvalue("ss_passwd_1")
    local ss_method_1 = LuciHttp.formvalue("ss_method_1") 
    local ss_local_port_1 = LuciHttp.formvalue("ss_local_port_1")
    local ssr_enable_1 = LuciHttp.formvalue("ssr_enable_1")
    local ssr_protocol_1 = LuciHttp.formvalue("ssr_protocol_1")
    local ssr_obfs_1 = LuciHttp.formvalue("ssr_obfs_1")
    
    local ss_server_2 = LuciHttp.formvalue("ss_server_2")
    local ss_server_port_2 = LuciHttp.formvalue("ss_server_port_2")
    local ss_passwd_2 = LuciHttp.formvalue("ss_passwd_2")
    local ss_method_2 = LuciHttp.formvalue("ss_method_2") 
    local ss_local_port_2 = LuciHttp.formvalue("ss_local_port_2")
    local ssr_enable_2 = LuciHttp.formvalue("ssr_enable_2")
    local ssr_protocol_2 = LuciHttp.formvalue("ssr_protocol_2")
    local ssr_obfs_2 = LuciHttp.formvalue("ssr_obfs_2")
    
    local set = true
    
    LuciUtil.exec("uci set misstar.ss.enable=" ..ss_enable)
    LuciUtil.exec("uci set misstar.ss.ss_mode=" ..ss_mode)
    LuciUtil.exec("uci set misstar.ss.node_switch=" ..node_switch)
    LuciUtil.exec("uci set misstar.ss.dns_mode=" ..dns_mode)
    
    
	LuciUtil.exec("uci set misstar.ss.ss_server_1=" ..ss_server_1)
    LuciUtil.exec("uci set misstar.ss.ss_server_port_1=" ..ss_server_port_1)
    LuciUtil.exec("uci set misstar.ss.ss_password_1=" ..ss_passwd_1)
    LuciUtil.exec("uci set misstar.ss.ss_method_1=" ..ss_method_1)
    LuciUtil.exec("uci set misstar.ss.ss_local_port_1=" ..ss_local_port_1)
    LuciUtil.exec("uci set misstar.ss.ssr_enable_1=" ..ssr_enable_1)
    LuciUtil.exec("uci set misstar.ss.ssr_protocol_1=" ..ssr_protocol_1)
    LuciUtil.exec("uci set misstar.ss.ssr_obfs_1=" ..ssr_obfs_1)
    
    LuciUtil.exec("uci set misstar.ss.ss_server_2=" ..ss_server_2)
    LuciUtil.exec("uci set misstar.ss.ss_server_port_2=" ..ss_server_port_2)
    LuciUtil.exec("uci set misstar.ss.ss_password_2=" ..ss_passwd_2)
    LuciUtil.exec("uci set misstar.ss.ss_method_2=" ..ss_method_2)
    LuciUtil.exec("uci set misstar.ss.ss_local_port_2=" ..ss_local_port_2)
    LuciUtil.exec("uci set misstar.ss.ssr_enable_2=" ..ssr_enable_2)
    LuciUtil.exec("uci set misstar.ss.ssr_protocol_2=" ..ssr_protocol_2)
    LuciUtil.exec("uci set misstar.ss.ssr_obfs_2=" ..ssr_obfs_2)
    

	LuciUtil.exec("uci commit misstar ")
	
	LuciUtil.exec("/etc/misstar/scripts/ss restart ")
	
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

function add_pac()
	local code = 0
	local result = {}
	local address=LuciHttp.formvalue("address")
	code=LuciUtil.exec("/etc/misstar/scripts/misstar ss addpac " ..address)
	result["code"] = code
	if result.code ~= 0 then
        result["msg"] = "添加失败。"
    end
    LuciHttp.write_json(result)
end

function del_pac()
	local code = 0
	local result = {}
	local address=LuciHttp.formvalue("address")
	code=LuciUtil.exec("/etc/misstar/scripts/misstar ss delpac " ..address)
	result["code"] = code
	if result.code ~= 0 then
        result["msg"] = "删除失败。"
    end
    LuciHttp.write_json(result)
end

function add_white()
	local code = 0
	local result = {}
	local address=LuciHttp.formvalue("address")
	code=LuciUtil.exec("/etc/misstar/scripts/misstar ss addwhite " ..address)
	result["code"] = code
	if result.code ~= 0 then
        result["msg"] = "添加失败。"
    end
    LuciHttp.write_json(result)
end


function del_white()
	local code = 0
	local result = {}
	local address=LuciHttp.formvalue("address")
	code=LuciUtil.exec("/etc/misstar/scripts/misstar ss delwhite " ..address)
	result["code"] = code
	if result.code ~= 0 then
        result["msg"] = "删除失败。"
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
	LuciUtil.exec("uci commit misstar ")
	LuciUtil.exec("/etc/misstar/scripts/adm restart ")
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

function set_kms()
    local code = 0
    local result = {}
    local set=false
    local kms_enable_switch=LuciHttp.formvalue("kms_enable_switch")
    local kms_wan=LuciHttp.formvalue("kms_wan")
	LuciUtil.exec("uci set misstar.kms.enable=" ..kms_enable_switch)
	LuciUtil.exec("uci set misstar.kms.kms_wan=" ..kms_wan)	
	LuciUtil.exec("uci commit misstar ")
	LuciUtil.exec("/etc/misstar/scripts/kms restart ")
    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("adm_enable_switch")
    end
    LuciHttp.write_json(result)
end



function get_kms()
	local result = {}
	local adm_enable
	kms_enable = uci:get("misstar","kms","enable")
	kms_wan = uci:get("misstar","kms","kms_wan")
	result["code"]=0
	result["kms_enable"]=kms_enable
	result["kms_wan"]=kms_wan
	LuciHttp.write_json(result)
end


function set_rm()
    local code = 0
    local result = {}
    local set=false
    local web_enable_switch=LuciHttp.formvalue("web_enable_switch")
    local sshd_enable_switch=LuciHttp.formvalue("sshd_enable_switch")
    local web_port=LuciHttp.formvalue("web_port")
	LuciUtil.exec("uci set misstar.web.enable=" ..web_enable_switch)
	LuciUtil.exec("uci set misstar.web.web_port=" ..web_port)
	LuciUtil.exec("uci set misstar.sshd.enable=" ..sshd_enable_switch)
	LuciUtil.exec("uci commit misstar")
	if web_enable_switch then
		LuciUtil.exec("/etc/misstar/scripts/misstar web enable")
	else
		LuciUtil.exec("/etc/misstar/scripts/misstar web disable")
	end
	if sshd_enable_switch then
		LuciUtil.exec("/etc/misstar/scripts/misstar sshd enable")
	else
		LuciUtil.exec("/etc/misstar/scripts/misstar sshd disable")
	end
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
	web_port = uci:get("misstar","web","web_port")
	sshd_enable = uci:get("misstar","sshd","enable")
	result["code"]=0
	result["web_enable"]=web_enable
	result["sshd_enable"]=sshd_enable
	result["web_port"]=web_port
	LuciHttp.write_json(result)
end

function set_webshell()
    local code = 0
    local result = {}
    local set=false
    local webshell_enable_switch=LuciHttp.formvalue("webshell_enable_switch")
	LuciUtil.exec("uci set misstar.webshell.enable=" ..webshell_enable_switch)
	LuciUtil.exec("uci commit misstar ")
	LuciUtil.exec("/etc/misstar/scripts/webshell restart ")
	
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
	LuciUtil.exec("uci commit misstar ")
	LuciUtil.exec("/etc/misstar/scripts/aria2 restart ")
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
	ss_status=LuciUtil.exec("ps | grep -E 'ss-redir|ssr-redir' | grep -v 'grep' | wc -l")
	version=uci:get("misstar","misstar","version")
	adm_status=LuciUtil.exec("ps | grep adm | grep -v grep | wc -l")
	ftp_status=LuciUtil.exec("ps | grep vsftp | grep -v grep | wc -l")
	web_status=uci:get("misstar","web","enable")
	ssh_status=uci:get("misstar","sshd","enable")
	webshell_status=LuciUtil.exec("ps | grep shellinabox | grep -v grep | wc -l")
	xlkn_status=0
	aria2_status=LuciUtil.exec("ps | grep aria2c | grep -v grep | wc -l")
	kms_status=LuciUtil.exec("ps | grep kms | grep -v grep | wc -l")
	result["code"]=0
	result["ss_status"]=ss_status
	result["version"]=version
	result["xlkn_status"]=xlkn_status
	result["adm_status"]=adm_status
	result["ftp_status"]=ftp_status
	result["web_status"]=web_status
	result["ssh_status"]=ssh_status
	result["aria2_status"]=aria2_status
	result["webshell_status"]=webshell_status
	result["kms_status"]=kms_status
	LuciHttp.write_json(result)
end
