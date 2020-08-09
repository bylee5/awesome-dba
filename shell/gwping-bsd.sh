#!/bin/sh

# 56. 디폴트 게이트웨이에 ping이 통하는지
# 확인하기(FreeBSD/Mac)

# nestat 명령어 출력에서 디폴트 게이트웨이 얻기
# 첫 번째 컬럼이 default인 줄의 두 번째 컬럼 추출
gateway=$(nestat -nr | awk '$1 == "default" {print $2}')

# 디폴트 게이트웨이에 ping
ping -c 1 $gateway > /dev/null 2>&1

# ping 명령어 종료 스테이터스로 판단
if [ $? -eq 0 ]; then
  echo "[Success] ping -> $gateway"
else
  echo "[Failed] ping -> $gateway"
fi