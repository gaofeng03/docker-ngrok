############################################################

# Dockerfile to build ngrok container images

# Based on daocloud.io/golang:1.4.0

############################################################
# base
FROM daocloud.io/golang:1.4.0
MAINTAINER lewis.gao/gaofeng03@163.com
USER root
# env
ENV NGROK_HOST tunnel.monogogo.cn
ENV NGROK_HTTP_ADDR 80
ENV NGROK_HTTPS_ADDR 443
# 1. ngrok download
WORKDIR /root
RUN git clone https://github.com/inconshreveable/ngrok.git
ADD ngrok-build.sh ./
ADD ngrok-server.sh ./
ADD watchdog.sh ./
ADD watchdog.txt ./
RUN mkdir /usr/ngrok
RUN mkdir /usr/ngrok/sh
ADD ngrok.cfg /usr/ngrok/
ADD ngrok-ssh.sh /usr/ngrok/
ADD ngrok-client.sh /usr/ngrok/
ADD watchdog.sh /usr/ngrok/
ADD watchdog-client.txt /usr/ngrok/
ADD ngrok /usr/ngrok/sh/
# run
# /root/ngrok.sh