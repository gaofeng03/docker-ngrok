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
# 2. cert
RUN ls
WORKDIR /root/ngrok
RUN mkdir cert
WORKDIR /root/ngrok/cert
RUN openssl genrsa -out rootCA.key 2048
RUN openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_HOST" -days 5000 -out rootCA.pem
RUN openssl genrsa -out device.key 2048
RUN openssl req -new -key device.key -subj "/CN=$NGROK_HOST" -out device.csr
RUN openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000
# 3. key
RUN cp rootCA.pem /root/ngrok/assets/client/tls/ngrokroot.crt
RUN cp device.crt /root/ngrok/assets/server/tls/snakeoil.crt
RUN cp device.key /root/ngrok/assets/server/tls/snakeoil.key
# 4. make
WORKDIR /root/ngrok
RUN make release-server
RUN make release-client
# 5. run
# RUN /root/ngrok/bin/ngrokd -domain="$NGROK_HOST" -httpAddr=":$NGROK_HTTP_ADDR" -httpsAddr=":$NGROK_HTTPS_ADDR"