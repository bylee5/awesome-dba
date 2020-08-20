#!/bin/sh

# 67. 로컬 셸 스크립트 파일을 원격 호스트에서 그대로 실행하기

username="user1"
script="check.sh"

cat $script | ssh ${username}@192.168.2.4 "sh"
cat $script | ssh ${username}@192.168.2.5 "sh"
cat $script | ssh ${username}@192.168.2.6 "sh"