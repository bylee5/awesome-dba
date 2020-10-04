#!/bin/sh

# 104. 서버 네트워크 인터페이스와
# ip 주소 목록 얻기

# ifconfig 명령어로 유효한 인터페이스 표시
# awk 명령어로 인터페이스명과 ip 주소 추출
LANG=C /sbin/ifconfig |\
awk '/^[a-z]/ {print "[" $1 "]"}
/inet / {split($2,arr,":"); print arr[2]}'