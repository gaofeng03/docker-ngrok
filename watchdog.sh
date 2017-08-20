#!/usr/bin/env bash

#nohup ./ngrokd -domain=tunnel.huicode.top -httpAddr=":8080" -httpsAddr=":443">ngrok.log &
#nohup ./start-server.sh

domain=http://blog.tunnel.monogogo.cn:8088/
httpAddr=8088
httpsAddr=8089
KEEPALIVE=5
MAX_KEEPALIVE=1800

watchdog_pid="`ps -ef | grep -v grep | grep watchdog | sed -n  '1P' | awk '{print $2}'`"

heartbeat() {
    while [ 1 ]
        do
            echo "===================================================="
            echo ""
            echo "【KEEPALIVE：$KEEPALIVE】"
            echo ""
            echo "===================================================="

            ngrok_pid="`ps -ef | grep -v grep | grep ngrok | sed -n  '1P' | awk '{print $2}'`"
            ngrok_http="$`(curl -I -s $domain -w %{http_code})`"
            ngrok_status=${ngrok_http:9:3}

            if [ -n "$ngrok_pid" ] && [ -n "$ngrok_status" ]
            then
                echo "===================================================="
                echo "ngrok up"
                echo "===================================================="
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
    pkill ngrok
    service ngrok restart
}

banner(){
    echo "        |================================================|    "
    echo "        .......................START......................    "
    echo "        |                                                |    "
    echo "        ....................author:lewis................ |    "
    echo "        |================================================|    "
}

bootstrap() {
    if [ -n "$watchdog_pid" ]
    then
        echo "===================================================="
        echo "watchdog up"
        echo "===================================================="
    else
        echo "watch ngrok server !!!"
        banner
        heartbeat
    fi
}

bootstrap>>ngrok_blog_monogogo.log;