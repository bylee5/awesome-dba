#!/bin/sh

# 24. 명령어 사용법을 표시할 때
# 현재 파일명 표시하기
prog=$(basename "$0")

# 인수가 하나가 아니면 도움말을 표시하고 종료
if [ $# -ne 1 ]; then
  echo "Usage: $prog <string>" 1>&2
  exit 1
fi

# 명령행 인수 $1 표시
echo "Start: $prog ..."
echo " Input Argument: $1"
echo "Stop: $prog ..."