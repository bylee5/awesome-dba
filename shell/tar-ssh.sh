#!/bin/sh

# 35. 로컬 디렉터리에 파일을 만들지 않고
# 직접 원격 호스트에 아카이브하기

username="user1"
server="192.168.1.5"

tar cvf - myapp/log | ssh ${username}@{server} "cat > /backup/mysqllog.tar"