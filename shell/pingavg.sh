#!/bin/sh

# 57. ping으로 특정 호스트 응답 평균 시간을 취득하기

ipaddr="192.168.2.1"
count=10

echo "Ping to: $ipaddr"
echo "Ping count: $count"
echo "Ping average[ms]:"

# ping 명령어 실행 결과를 임시 파일에 출력
ping -c $count $ipaddr > ping.$$

# "time=4.32 ms" 부분을 sed로 추출, awk로 평균값 계산
sed -n "s/^.*time=\(.*\) ms/\1/p" ping.$$ |\
awk '{sum+=$1} END{print sum/NR}'

# 임시 파일 삭제
rm -f ping.$$