#!/bin/bash

# 125. for 반복문을 간단히 작성하기

# bash 브레이스 확장 {}으로 ip 주소 목록 작성
for ipaddr in 192.168.2.{1..5}
do
  ping -c 1 "$ipaddr" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "[OK] Ping -> $ipaddr"
  else
    echo "[NG] Ping -> $ipaddr"
  fi
done