#!/bin/sh

# 110. 서버 구축 패키지 목록을
# 셸 스크립트 형태로 관리하기

# 설치할 패키지명 정의
pkglist="httpd zsh xz git"

# 패키지 목록에서 순서대로 한 줄씩 읽기
for pkg in $pkglist
do
  # yum 명령어로 패키지 설치
  yum -y install $pkg
done