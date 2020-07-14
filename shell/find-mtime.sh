#!/bin/sh

# 30. 특정 디렉터리에서 n일 전부터
# m일 전까지 변경된 파일 목록 얻기

logdir="/var/log/myapp"

# 4일 전부터 2일 전까지 갱신된 파일 목록을 표시
find $logdir -name "*.log" -mtime -4 -mtime +1 -print