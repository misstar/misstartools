#!/bin/sh /etc/rc.common

START=65
NAME=pdnsd
DESC="proxy DNS server"

## Check The Router Hardware Model 
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
                                                
