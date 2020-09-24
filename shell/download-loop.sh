#!/bin/sh

# 100. 강제 종료될 때까지 파일 내려받기를
# 반복해 통신 확인하기

# 확인 대상 url
url=http://192.168.22.1/webapi/check

# 무한 반복 시작
while true
do
  # curl 명령어에서 테스트 대상 url 내려받기
  # 파일 자체는 필요 없으므로 /dev/null로
  curl -so /dev/null "$url"

  # curl 명령어 종료 스테이터스로 OK, NG 판정
  if [ $? -eq 0]; then
    echo "[check OK]"
  else
    echo "[check NG]"
  fi

  # 5초 대기
  sleep 5
done