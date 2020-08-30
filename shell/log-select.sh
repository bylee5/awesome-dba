#!/bin/sh

# 77. 웹 서버 로그 파일에서
# 특정 상태값만 취득하기

logfile="access_log"

# 로그 파일이 존재하지 않으면 종료
if [ ! -f "$logfile" ]; then
  echo "대상 로그 파일이 존재하지 않습니다: $logfile" >&2
  exit 1
fi

# HTTP 스테이터스를 외부 파일에 출력
awk '$(NF-1)==404 {print $7}' "$logfile" > "${logfile}.404"