#!/bin/sh
# 2. cert
cd /root/ngrok
mkdir cert
cd /root/ngrok/cert
openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=$NGROK_HOST" -days 5000 -out rootCA.pem
openssl genrsa -out device.key 2048
openssl req -new -key device.key -subj "/CN=$NGROK_HOST" -out device.csr
openssl x509 -req -in device.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out device.crt -days 5000
# 3. key
cp rootCA.pem /root/ngrok/assets/client/tls/ngrokroot.crt
cp device.crt /root/ngrok/assets/server/tls/snakeoil.crt
cp device.key /root/ngrok/assets/server/tls/snakeoil.key
# 4. make
cd /root/ngrok
make release-server release-client
cp /root/ngrok/bin/ngrok /usr/ngrok
# 5. run
/root/ngrok/bin/ngrokd -domain="$NGROK_HOST" -httpAddr=":$NGROK_HTTP_ADDR" -httpsAddr=":$NGROK_HTTPS_ADDR"