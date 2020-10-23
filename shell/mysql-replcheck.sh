#!/bin/sh

# 121. mysql 레플리케이션 감시하기

# 데이터베이스 접속 설정. 슬레이브 서버에 접속
DBHOST="192.168.11.5"
DBUSER="operator"
DBPASS="PASSWORD"

# mysql 명령어 경로 지정과 임시 파일 정의
MYSQL="/usr/bin/mysql"
resulttmp="tmp.$$"

# show slave status 실행 결과를 임시 파일에 출력
$MYSQL -h "${DBHOST}" -u "${DBUSER}" -p "${DBPASS}" -e "show slave status \G" > $resulttmp

# 레플리케이션 상태 관련 파라미터 추출
Slave_IO_Running=$(awk '/Slave_IO_Running:/ {print $2}' "$resulttmp")
Slave_SQL_Running=$(awk '/Slave_SQL_Running:/ {print $2}' "$resulttmp")
Last_IO_Error=$(grep 'Last_IO_Error:' "$resulttmp" | sed 's/^ *//g')
Last_SQL_Error=$(grep 'Last_SQL_Error:' "$resulttmp" | sed 's/^ *//g')

# 현재 시각을 2013/02/01 13:15:44 형태로 좋ㅂ
date_str=$(date '+%Y/%m/%d %H:%M:%S')

# Slave_IO_Running과 Slave_SQL_Running이 둘다 YES가 아니면 에러
if [ "$Slave_IO_Running" = "YES" -a "$Slave_SQL_Running" = "YES" ]; then
  echo "[$date_str] STATUS OK"
else
  echo "[$date_str] STATUS NG"
  echo "Slave_IO_Running: $Slave_IO_Running"
  echo "Slave_SQL_Running: $Slave_SQL_Running"
  echo "$Last_IO_Error"
  echo "$Last_SQL_Error"

  # 경고 메일 등 출력
  /home/user1/bin/alert.sh
fi
# 임시 파일 삭제
rm -f "$resulttmp"