#!/bin/sh

# 58. arp 테이블에서 지정 IP 주소에
# 대응하는 MAC 주소를 표시하기

ipaddr="192.168.2.1"

macaddr=$(arp -ap | awk "/\($ipaddr\)/ {print \$4}")

if [ -n "$macaddr" ]; then
  echo "$ipaddr -> $macaddr"
else
  echo "$ipaddr가 ARP 캐쉬에 없습니다."
fi