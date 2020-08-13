#!/bin/sh

# 60. IP 주소로 호스트명을 얻기

while read ipaddr
do
  # host 명령어로 IP 주소 변환
  revlookup=$(host "$ipaddr")

  # host 명령어가 성공했는지
  if [ $? -eq 0 ]; then
    echo -n "$ipaddr,"
    # host 명령어 출력을 awk로 호스트명만 표시
    echo "$revlookup" | awk '{print $NF}' | sed 's/\.$//'
  else
    echo "$ipaddr,"
  fi
  # DNS 서버 부하 경감을 위해 1초간 대기

  sleep 1
done < $1