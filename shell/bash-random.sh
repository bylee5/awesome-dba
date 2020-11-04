#!/bin/bash

# 132. 정수값으로 난수 얻기

# 접속 정보 정의
ipaddr="192.168.2.1"
port=80

# 1에서 10까지의 정수값 난수를 RANDOM 변수에서 얻기
waittime=$((RANDOM % 10 + 1))

# 테스트 명령어를 sleep하며 2회 실행
nc -w 5 -zv $ipaddr $port
echo "Wait: $waittime sec."
sleep $waittime
nc -w 5 -zv $ipaddr $port