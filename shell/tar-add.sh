#!/bin/sh

# 39. tar 아카이브에 파일 추가하기

# 년월로 아카이브 파일 지정(예: 201312.tar)
archivefile="$(date +'%Y%m').tar"
# 오늘 날짜로 로그 파일 지정(예: 20131205.log)
logfile="$(date +'%Y%d').log"
# 월별 아카이브에 오늘 로그 추가
tar rvf $archivefile log/$logfile