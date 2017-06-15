############################################################

# Dockerfile to build ngrok container images

# Based on daocloud.io/golang:1.4.0

############################################################
# base
FROM daocloud.io/golang:1.4.0
MAINTAINER lewis.gao/gaofeng03@163.com
USER root
# env
ENV NGROK_HOST monogogo.cn
ENV NGROK_HTTP_ADDR 80
ENV NGROK_HTTPS_ADDR 443
# 1. ngrok download
WORKDIR /root
RUN git clone https://github.com/inconshreveable/ngrok.git
ADD ngrok.sh ./
# run
# /root/ngrok.sh