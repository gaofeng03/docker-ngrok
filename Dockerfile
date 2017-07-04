############################################################

# Dockerfile to build ngrok container images

# Based on daocloud.io/golang:1.4.0

############################################################
# base
FROM daocloud.io/golang:1.4.0
MAINTAINER lewis.gao/gaofeng03@163.com
USER root

# env default params
ENV NGROK_HOST tunnel.monogogo.cn
ENV NGROK_HTTP_ADDR 80
ENV NGROK_HTTPS_ADDR 443

# 1、ngrok download
WORKDIR /root
RUN git clone https://github.com/inconshreveable/ngrok.git

# cp ngrok server shell
ADD ngrok-build.sh ./
ADD ngrok-server.sh ./

# watch server
ADD watchdog.sh ./
ADD watchdog-server.txt ./

# 2、creat ngrok dir
RUN mkdir /usr/ngrok
RUN mkdir /usr/ngrok/sh

# cp ngrok client file
ADD ngrok.cfg /usr/ngrok/
ADD ngrok-ssh.sh /usr/ngrok/
ADD ngrok-client.sh /usr/ngrok/

# watch client file
ADD watchdog.sh /usr/ngrok/
ADD watchdog-client.txt /usr/ngrok/

# service
ADD ngrok /usr/ngrok/sh/

# 3、run 
# /root/ngrok-server.sh