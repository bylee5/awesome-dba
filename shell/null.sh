#!/bin/sh

# 27. 파일 내용을 삭제해서 빈 파일로 만들기
# uptime 명령어 기록 파일 정의
uptimelog="uptime.log"

# 널 명령어로 빈 파일로 초기화
: > $uptimelog

# 10초마다 6번, uptime 명령어 실행
for i in 1 2 3 4 5 6
do
  uptime >> $uptimelog
  sleep 10
done