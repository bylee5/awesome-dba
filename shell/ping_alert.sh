#!/bin/sh

# 114. 서버 ping 감시하기

# ping 실행 결과 스테이터스, 0이면 성공이므로 1로 초기화
result=1

# 대상 서버가 명령행 인수로 지정되지 않으면 에러 종료
if [ -z "$1" ]; then
  echo "대상 호스트를 지정하세요." >&2
  exit 1
fi

# ping 명령어를 3회 실행. 성공하면 result를 0으로
i=0
while [ $i -lt 3 ]
do
  # ping 명령어 실행. 종료 스테이터스만 필요하므로
  # /dev/null에 리다이렉트
  ping -c 1 "$1" > /dev/null

  # ping 명령어 종료 스테이터스 판별. 성공하면 result=0으로 반복문 탈출
  # 실패하면 3초 대기 후 재실행
  if [ $? -eq 0 ]; then
    result=0
    break
  else
    sleep 3
    i=$(expr $i + 1)
  fi
done