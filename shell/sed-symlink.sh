#!/bin/sh

# 50. sed로 파일 치환 시 심볼릭 링크를
# 실제 파일로 바꾸지 않게 하기

filename="target.txt"

if [ ! -e "$filename" ]; then
  # 대상 파일이 존재하지 않으면 에러 종료
  echo "ERROR: File not exists." >&2
  exit 1
elif [ -h "$filename" ]; then
  # 대상 파일이 심볼릭 링크면 readlink 명령어로
  # 실제 파일을 대상으로 처리하기
  sed -i.bak "s/Hello/Hi/g" "$(readlink "$filename")"
else
  sed -i.bak "s/Hello/Hi/g" "$filename"
fi