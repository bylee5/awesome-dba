#!/bin/sh

# 67.
# script-remote.sh 파일과 관련있음
# 개통 확인할 대상 서버
checkserver="19.168.2.35"

# 스크립트를 실행한 호스트명 표시
hostname

# 서버 개통을 ping 명령어로 확인
ping -c 1 "$checkserver" > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "Ping to $checkserver: [OK]"
else
  echo "Ping to $checkserver: [NG]"
fi