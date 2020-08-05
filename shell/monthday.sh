#!/bin/sh

# 52. 오늘이 말일인지 판별하기

tomorrow=$(date "+%d" -d '1 day')

if [ "$tomorrow" = "01" ]; then
  # 오늘이 말일이라면 월별 리포트를 작성하는 외부 스크립트 실행
  ./monthly_report.sh
fi