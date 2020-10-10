#!/bin/sh

# 109. rpm 패키지명이 적힌 목록 파일에서
# 각각의 패키지가 설치, 갱신된 날짜를 확인하기

# 지정된 목록 파일 존재 확인
if [ ! -f "$1" ]; then
  echo "대상 패키지 목록 파일이 조재하지 않습니다: $1" >&2
  exit 1
fi

# 인수로 지정한 파일($1)에서 패키지 목록 얻기
pkglist=$(cat "$1")

# 설치된 rpm 갱신일자 출력
rpm -q $pkglist --queryformat '%{INSTALLTIME:date} : %{NAME}\n'