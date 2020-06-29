#!/bin/sh

# 17. 문장 속 공백문자를 포함한 문자열 변수를
# 인수로 쓰기
result="invalid value"

if [ "$result" = "invalid value" ]; then
  echo "ERROR: $result" 1>&2
  exit 1
fi
