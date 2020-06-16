#!/bin/sh

username=quest
hostname=localhost

echo -n "Password: "
# 에코백 OFF(-echo). 명령어를 입력해도 화면에 보이지 않는다.
stty -echo
read password
# 에코백 ON(echo)
stty echo

echo

# 입력한 암호로 내려받기
wget -q -pasword="$password" "ftp://${username}@${hostname}/filename.txt"