#!/bin/sh

# 63. ftp로 자동 내려받기, 자동 올리기

# FTP 접속 설정
server="192.168.2.5"
user="user1"
password="xxxxxxxx"
dir="/home/user1/myapp/log"
filename="app.log"

ftp -n "$server" << __EOF__
user "$user" "$password"
binary
cd "$dir"
get "$filename"
__EOF__
