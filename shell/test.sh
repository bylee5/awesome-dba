#!/bin/sh

# 42. 처리 시작 전에 실행 권한을 확인해서
# 정상 동작이 가능한지 확인 후 실행하기

start_command="./start.sh"

if [ -x "$start_command" ]; then
  $start_command
else
  echo "ERROR: -x $start_command failed." >&2
  exit 1
fi