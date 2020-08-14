#!/bin/sh

# 61. 서버의 특정 포트가 열려 있는지
# 확인하는 스크립트 작성하기

ipaddr="192.168.2.52"
faillog="fail-port.log"

# 확인할 포트는 80, 2222, 8080
for port in 80 2222 8080
do
  nc -w 5 -z $ipaddr $port

  if [ $? -ne 0 ]; then
    echo "Failed at port: $port" >> "$faillog"
  fi
done