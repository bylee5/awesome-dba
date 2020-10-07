#!/bin/sh

# 107. 시스템 셧다운하기

# 자기 이외의 사용자가 로그인하지 않았는지 who 명령어 출력으로 확인
other_user=$(who | wc -l)
if [ "$other_user" -ge 2 ]; then
  echo "[ERROR] who 명령어 출력이 2줄 이상 : 작업 중인 사용자가 있습니다." >&2
  exit 1
fi

# 미리 정지해야 할 프로세스가 아직 남아 있는지 확인
commname="/usr/libexec/mysqld"
ps ax -o command | grep -q "^$commname"
if [ $? -eq 0 ]; then
  echo "[ERROR] 셧다운 중지 : 프로세스 $commname 실행 중" >&2
  exit 2
fi

# 셧다운 실행. Mac/FreeBSD는 주의사항 참조
shutdown -h now