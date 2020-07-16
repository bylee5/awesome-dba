#!/bin/sh

# 32. 로그 파일이 엄청 많은 디렉터리에서
# 파일들에 명령어를 일괄 실행하기

logdir="/var/log/myapp"

# 확장자 .log 파일에서 "ERROR" 문자열 검색
find $logdir -name "*.log" -print | xargs grep "ERROR" /dev/null