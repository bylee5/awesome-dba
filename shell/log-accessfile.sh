#!/bin/sh

# 79. 웹 접속 로그에서 파일별 접속횟수 집계하기

logfile="access_log"

# 로그 파일이 존재하지 않으면 종료
if [ ! -f "$logfile" ]; then
  echo "대상 로그 파일이 존재하지 않습니다: $logfile" >&2
  exit 1
fi

# 로그 파일에서 GET 메서드로 취득한 파일 접속 횟수 집계
# awk 명령어로 파일을 추출해서 sort+uniq으로 카운트해서 역순 정렬
awk '$6=="\"GET" {print $7}' "$logfile" | sort | uniq -c | sort -nr