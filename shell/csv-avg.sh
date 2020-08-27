#!/bin/sh

# 74. 숫자로 된 csv 파일에서 평균값 구하기

# data.csv
# 0001,Kim,45
# 0002,Lee,312

# csv 파일이 존재하지 않으면 종료
if [ ! -f "$1" ]; then
  echo "대상 csv 파일이 존재하지 않습니다: $1" >&2
  exit 1
fi

# 확장자를 제외한 파일명 취득
filename=${1%.*}

awk -F, '{sum += $3} END{print sum / NR}' "$1" > ${filename}.avg