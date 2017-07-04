#!/bin/sh
# 复制文件
cp -rf /usr/ngrok /root/
# 更改文件权限
chmod 755 ngrok-ssh.sh
# 开机启动
cp /usr/ngrok/sh/ngrok /etc/init.d/
cd /etc/init.d/
# 更改文件权限
chmod 755 ngrok
# 注册开机启动
sudo update-rc.d ngrok defaults 90
# 测试服务是否能启动成功(ubuntu)
service ngrok start
# 检查自启动的服务(centos)
# chkconfig