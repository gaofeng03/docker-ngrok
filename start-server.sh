#!/usr/bin/env bash

domain=tunnel.monogogo.cn
httpAddr=8088
httpsAddr=8089
KEEPALIVE=5
MAX_KEEPALIVE=1800

pid="`ps -ef | grep -v grep | grep $httpAddr | sed -n  '1P' | awk '{print $2}'`"

heartbeat() {
    while [ 1 ]
        do
            echo "===================================================="
            echo ""
            echo "【KEEPALIVE：$KEEPALIVE】"
            echo ""
            echo "===================================================="

            if [ -n "$pid" ] ;
            then
                debug ""
                debug "ngrok up"
                debug ""
            else
                reboot
            fi
            if [ $KEEPALIVE -lt $MAX_KEEPALIVE ] ; then
                KEEPALIVE=$((3+KEEPALIVE))
            fi
            sleep $KEEPALIVE;
    done
}

reboot() {
    debug "ngrok server will reboot !!!"
    if [ -n "$pid" ]; then
        debug "will killing [PID:$pid] ngrok restart !!!"
        kill -9 $pid
    fi
    ./ngrokd -domain=$domain -httpAddr=":$httpAddr" -httpsAddr=":$httpsAddr" &
    KEEPALIVE=5
}

debug() {
    echo $@
}

banner(){
echo "        |================================================|    "
echo "        .......................START......................    "
echo "        |                                                |    "
echo "        .......................dev:HUI.................. |    "
echo "        |                                                |    "
echo "        .......................START......................    "
echo "        |                                                |    "
echo "        .......................START......................    "
echo "        |================================================|    "
}

bootstrap() {
    echo "bootstrap ngrok server !!!"
    banner
    heartbeat
}

bootstrap>>ngrokd.log;


if [ -n "$ngrok_pid" ] ;
then
    echo "===================================================="
    echo "ngrok up"
    echo "===================================================="
else
    echo "reboot"
fi