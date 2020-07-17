#!/bin/sh

# 33. 파일을 백업할 때 파일명에 날짜 넣기

config="myapp.conf"

bak_filename="${config}.$(date '+%Y%m%d')"

# 이미 myapp.conf.20131202 등이 있으면 초까지 넣어서 백업 파일 작성
if [ -e $bak_filename ]; then
  bak_filename="${config}.$(date '+%Y%%d%H%M.%S')"
fi

cp -v "$config" "$bak_filename"