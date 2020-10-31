#!/bin/bash

# 128. 변수 내부 문자열 일부를 치환하기

# 조사할 명령어 얻기
command="$1"

# 인수 확인
if [ -z "$command" ]; then
  echo "에러: 조사 대상 명령어를 지정하세요." >&2
  exit 1
fi

# 환경 변수 $PATH의 :의 스페이스로 치환, for문 반복에서 사용
for dir in ${PATH//:/ }
do
  if [ -f "${dir}/${command}" ]; then
    echo "${dir}/${command}"
  fi
done