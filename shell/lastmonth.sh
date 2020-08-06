#!/bin/sh

# 53. 한 달 전에 만든 로그 파일을
# 일괄 아카이브하기

logdir="/var/log/myapp"

# 이번달 15일 날짜 취득
thismonth=$(date '+%Y/%m/15 00:00:00')

# 지난달 날짜를 YYYYMM으로 취득
# 1 month ago는 지난달의 같은 '날(일)'이 되므로 말일을 피하도록
# 변수 thismonth에 15일을 지정함
last_YYYYMM=$(date -d "$thismonth -1 month age" '+%Y%m')

# 지난달 로그 파일을 아카이브
tar cvf ${last_YYYYMM}.tar ${logdir}/access.log-${last_YYYYMM}*