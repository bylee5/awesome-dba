#!/bin/bash

# 127. 변수 내부 문자열을 n 번째부터 m 번째까지 추출하기

# 지정한 ID 파일에서 $id $status를 한 줄씩
# read 명령어로 읽어들림
while read id status
do
  # 셸 변수 id 첫 두 글자가 AC인지 확인
  if [ "${id:0:2}" = "AC" ]; then
    echo "$id $status"
  fi
done < "$1"