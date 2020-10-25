#!/bin/sh

# 122. mysql 테이블을 csv로 출력하기

# 데이터베이스 접속 설정
DBHOT="192.168.11.5"
DBUSER="user1"
DBPASS="PASSWORD"
DBNAME="hamilton"

# CSV 파일 출력 경로와 리포트 작성용 SQL문 파일명 지정
csv_outputdir="/home/user1/output"
sqlfile="/home/user1/bin/select.sql"

# sql 파일 확인
if [ ! -f "$sqlfile" ]; then
  echo "SQL 파일ㅇ 존재하지 않습니다: $sqlfile" >&2
  exit 1
fi

# csv 파일 출력용 디렉터리 확인
if [ ! -d "$csv_outputdir" ]; then
  echo "csv 출력용 디렉터리가 존재하지 않습니다: $csv_outputdir" >&2
  exit 1
fi

# 오늘 날짜를 YYYYMMDD로 취득
today=$(date '+%Y%m%d')

# csv 출력. -N으로 컬럼명 생략
# tr 명령어로 탭을 쉼표로 변환
$MYSQL -h "${DBHOST}" -u "${DBUSER}" -p "${DBPASS}" -D "${DBNAME}" -N < "$sqlfile" | tr "\t" "," < "${csv_outputdir}/data-${today}.csv"