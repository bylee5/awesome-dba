#!/bin/sh

# 71. 입력 파일 해시값을 줄마다 추가해서 출력하기

# 해시값을 출력할 임시 파일을 초기화
tmpfile="hash.txt"
: > $tmpfile

# 셸 구분자를 줄바꿈만 인식하도록 변경
IFS='
'

# 지정한 텍스트 파일에서 한 줄씩 읽어들임
while read -r line
do
  # MD5 해시 취득
  # 명령어에 파일명이 따라오므로 첫 번째 컬럼만 추출
  echo -n "$line" | md5sum | awk '{print $1}' >> $tmpfile
done < $1

# 원본 텍스트 파일과 해시를 출력한 임시 파일을 쉼표로 연결해서 표시
paste -d, "$1" $tmpfile