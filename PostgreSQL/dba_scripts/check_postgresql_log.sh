#!/bin/bash

# 전달인자 > 0 이면 count 옵션을 설정한다.

if [ $# -eq 0 ]
  then
    cntflg='-c'
  else
    cntflg=''
fi

set $(date '+%m%d')
MMDD=$1

set $(date +%m)
MM=${1}
logdir=/var/log/postgresql/

echo "현재 오류 로그: ${logdir}postgresql.${MMDD}"
echo
echo -n "오류: "
grep ${cntflg} -i ERROR ${logdir}postgresql.${MMDD}
echo -n "경고: "
grep ${cntflg} -i WARNING ${logdir}postgresql.${MMDD}
echo -n "pg_hba: "
grep ${cntflg} -i pg_hba ${logdir}postgresql.${MMDD}