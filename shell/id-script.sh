#!/bin/sh

# 106. 허거된 사용자만 스크립트 실행 가능하게 하기

# 스크립트 실행을 허용할 사용자 정의
script_user="batch1"

# id 명령어로 현재 사용자를 취득, 정의와 일치하는지 확인
if [ $(id -nu) = "$script_user" ]; then
  # 허가 사용자면 배치 처리 실행
  ./batch_program
else
  echo "[ERROR] $script_user 사용자로 실행하세요." >&2
  exit 1
fi