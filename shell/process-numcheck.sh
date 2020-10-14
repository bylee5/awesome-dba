#!/bin/sh

# 11. 특정 프로세스 실행 개수가 제한값을 넘었는지 확인하기

# 감시할 프로세스 명령어와 프로세스 허용 수
commname="/home/user1/bin/calc"
threshold=3

# 프로세스 개수 카운트
counnt=$(ps ax -o command | grep "$commname" | grep -v "^grep" | wc -l)

# 프로세스 수가 허용값 이상이면 경고 처리
if [ "$count" -ge "$threshold" ]; then
  echo "[ERROR] 프로세스 $commname 다중 실행($count)" >&2
  /home/user1/bin/alert.sh
fi