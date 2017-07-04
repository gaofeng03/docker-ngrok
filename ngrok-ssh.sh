#!/bin/sh
# ngrok client start
/root/ngrok/ngrok -config=/root/ngrok/ngrok.cfg start-all

# 守护进程
bash /root/ngrok/watchdog.sh /root/ngrok/watchdog-client.txt