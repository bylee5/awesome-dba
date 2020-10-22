#!/bin/sh

# 120. mysql 데이터베이스 백업하기

# 데이터베이스 접속 설정
DBHOST="192.168.11.5"
DBUSER="backup"
DBPASS="PASSWORD"
DBNAME="hamilton"

# 데이터베이스 백업 설정
BACKUP_DIR="/home/user1/backup"
BACKUP_ROTATE=3
MYSQLDUMP="/usr/bin/mysqldump"

# 백업 출력할 디렉터리 확인
if [ ! -d "$BACKUP_DIR" ]; then
  echo "백업용 디렉터리가 존재하지 않습니다: $BACKUP_DIR" >&2
  exit 1
fi

# 오늘 날짜를 YYYYMMDD로 취득
today=$(date '+%Y%m%d')

# mysqldump 명령어로 데이터베이스 백업을 실행
$MYSQLDUMP -h "${DBHOST}" -u "${DBUSER}" -p "${DBPASS}" "${DBNAME}" > "${BACKUP_DIR}/${DBNAME}-${today}.dump"

# mysqldump 명령어 종료 스테이터스 $?로 성공, 실패 확인
if [ $? -eq 0 ]; then
  gzip "${BACKUP_DIR}/${DBNAME}-${today}.dump"

  # 오래된 백업 파일 삭제
  find "$BACKUP_DIR" -name "${DBNAME}-*.dump.gz" -mtime +${BACKUP_ROTATE} | xargs rm -find
else
  echo "백업 작성 실패:${BACKUP_DIR}/${DBNAME}-${today}.dump"
  exit 2
fi