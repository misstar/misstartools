#!/bin/sh /etc/rc.common

START=65
NAME=pdnsd
DESC="proxy DNS server"

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


DAEMON=/etc/misstar/$Hardware_model/pdnsd
PID_FILE=/var/run/$NAME.pid
CACHEDIR=/var/pdnsd
CONFIGPATH=/etc/misstar/.config/pdnsd.conf
CACHE=$CACHEDIR/pdnsd.cache

USER=root
GROUP=root

start() {
       echo -n "Starting $DESC: $NAME"

       gen_cache

       $DAEMON --daemon -p $PID_FILE -c $CONFIGPATH
       echo " ."
}

stop() {
       echo -n "Stopping $DESC: $NAME"
       killall pdnsd
       rm -rf $PID_FILE
       echo " ."
}

restart() {
       echo "Restarting $DESC: $NAME... "
       stop
       sleep 2
       start
}

gen_cache()
{
       if ! test -f "$CACHE"; then
               mkdir -p `dirname $CACHE`
               dd if=/dev/zero of="$CACHE" bs=1 count=4 2> /dev/null
               chown -R $USER.$GROUP $CACHEDIR
       fi
}
                                                
