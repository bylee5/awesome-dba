#!/bin/sh

# 87. 스크립트 실행할 때 시그널을 받아서
# 현재 실행 상태 출력하기

# 실행횟수
count=0

# 통신 대상 서버
server="192.168.2.105"

# 시그널 usr1 트랩 설정. 현재 $count 표시
trap 'echo "Try Count: $count"' USR1

# nc 명령어로 연속 통신 확인 반복
while [ "$count" -le 1000 ]
do
  # 카운터 1 늘리고 nc 명령어 실행
  # 마지막에 1초 대기
  count=$(expr $count + 1)
  nc -zv "$server" 80
  sleep 1
done