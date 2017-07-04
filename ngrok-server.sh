#i!/bin/sh

ngrokd_file="/root/ngrok/bin/ngrokd"
ngrokd_pid="`ps -ef | grep -v grep | grep ngrokd | sed -n  '1P' | awk '{print $2}'`"

# start ngrokd server
function start {
    /root/ngrok/bin/ngrokd -domain="$NGROK_HOST" -httpAddr=":$NGROK_HTTP_ADDR" -httpsAddr=":$NGROK_HTTPS_ADDR"
    echo "ngrokd start"
}

# build ngrokd server & client
function build {
    bash /root/ngrok-build.sh
    echo "ngrokd build"
}

# 守护进程
function watchdog {
    bash /root/watchdog.sh /root/watchdog-server.txt
}

# ngrokd 是否存在
if [ ! -e "$ngrokd_file" ] ; then
    echo "no ngrokd"
    build
    start
    watchdog
elif [ -z "$ngrokd_pid" ] ; then
    echo "no this process"
    start
    watchdog
fi