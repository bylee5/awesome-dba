#!/bin/sh

# 91. scp로 파일 전송할 때
# cpu 이용률을 계산해서 압축 처리를 할 것인지 판단하기

# 테스트 전송 파일명, 전송할 곳 등 정의
username="user1"
filename="transfer.dat"
hostname="192.168.2.10"
path="/var/tmp"
tmpfile="timetmp.$$"

# scp 명령어로 파일 전송
# time 명령어로 시간을 측정, 임시 파일에 출력
(time -p scp -C "$filename" ${username}@{hostname}:"${path}") 2>"$tmpfile"

# time 명령어 출력 임시 파일에서 각 time 추출
realtime=$(awk '/^real / {print $2}' "$tmpfile")
usertime=$(awk '/^user / {print $2}' "$tmpfile")
systime=$(awk '/^sys / {print $2}' "$tmpfile")

# cpu 사용 시간에서 cpu 사용률 계산
cpu_percentage=$(echo "scale=2; 100 * ($usertime + $systime) / $realtime" | bc)
echo "scp 전송 cpu 사용률 : $cpu_percentage (%)"

# 임시 파일 삭제
rm -f "$tmpfile"