#i!/bin/sh
# watchdog.sh

#定义映射表 k=进程号 v=作业
declare -A mapper
#进程号文件
conf=dog.pid
url=127.0.0.1:4040
anetKeepAlive=1800 #秒

function debug
{
    echo $@
}

#heartbeat
function heartbeat
{
    code=`curl -o /dev/null --retry 3 --retry-max-time 8 -s -w %{http_code} $url`
    echo "$url status $code">>heartbeat.log
    if test $[code] -eq 200;
    then
        echo "$url status $code";
    else
        #todo gf
    fi
}

#param pid 进程号
#使用ps命令查询该进程是否存在，如果不存在返回"gone"，否则返回"stay"

function watch
{
    local pid=$1
    local index=`ps -ef|awk '{print $2}'|grep -P "^${pid}$"`
    if [ "${index}None" = "None" ]; then
        echo gone
        return
    fi
    echo stay
}

#每过5秒钟检查一遍所有的进程，调用上面的watch

function dogit
{
    while [ 1 ]
    do
        sleep $anetKeepAlive
        for pid in ${!mapper[@]}
        do
            debug pid:$pid
            local t=`watch $pid`
            debug "test result is $t!!!"
            if [ "$t" = "gone" ]; then
                debug "$c with pid $pid was gone"
                loadscript ${mapper[$pid]}
                unset mapper[$pid]
                sed -i "/$pid/d" $conf
            fi
        done
    done
}

#从作业文件加载需要守护的作业命令

function loadscript
{
    local script=$@
    debug script=$script
    $script > /dev/null &
    local pid=$!
    mapper[$pid]=$script
    echo $pid >> $conf
}

function clean
{
    if [ -f $conf ]; then
        while read line; do
            if [ -n "$line" ]; then
                pid=`ps -ef|awk '{print $2}'|grep $line|grep -v 'grep'`
                if [ -n "${pid}" ]; then
                    debug killing $pid
                    kill $pid
                fi
            fi
        done < $conf
    fi
    echo > $conf
    debug done!
}

function main
{
    clean
    local file=$1
    if [ -f $file ]; then
        while read line
        do
            loadscript $line
        done < $file
        dogit
    else
        echo "Not a file!"
    fi
}

main $1;

urls=('www.baidu.com' 'www.google.com' 'www.lazysa.com'); for i in ${urls[@]}; do http_code=$(curl -I -s $i -w %{http_code}); echo $i status: ${http_code:9:3}; done