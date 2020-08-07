#!/bin/sh

# 54. 윤년인지 확인하기

# 네 자리 년도 얻기
year=$(date '+%Y')

logfile="/var/log/myapp/access.log-"

# 년도를 나눈 나머지 계산
mod1=$(expr $year % 4)
mod2=$(expr $year % 100)
mod3=$(expr $year % 400)

# 윤년인지 판정
if [ $mod1 -eq 0 -a $mod2 -ne 0 -o $mod3 -eq 0 ]; then
  echo "leap year:$year"
  ls "${logfile}${year}0229"
else
  echo "not leap year:$year"
  ls "${logfile}${year}0228"
fi