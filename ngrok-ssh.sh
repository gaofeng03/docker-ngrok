#!/bin/sh
# ngrok client start
nohup /root/ngrok/ngrok -config=/root/ngrok/ngrok.cfg start-all &

# 守护进程
nohup bash /root/ngrok/watchdog.sh &