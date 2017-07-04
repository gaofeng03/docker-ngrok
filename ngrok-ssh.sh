#!/bin/sh
# ngrok client start
/root/ngrok/ngrok -config=/root/ngrok/ngrok.cfg start-all

# 守护进程
bash /root/watchdog.sh /root/watchdog-client.txt