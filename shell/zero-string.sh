#!/bin/sh

# 101. id 컬럼을 00001처럼 0으로 채운 csv 파일에서
# 번호를 지정해서 값을 추출하기

# 추출 조건 등 정의
match_id=1  # 추출할 id
csvfile="data.csv"  # csv 파일 지정

# csv 파일이 없으면 종료
if [ ! -f "$csvfile" ]; then
  echo "csv 파일이 존재하지 않습니다: $csvfile" >&2
  exit 1
fi

# csv 파일 읽기
while read line
do
  # 각 컬럼을 cut으로 추출
  id=$(echo $line | cut -f 1 -d ',')
  name=$(echo $line | cut -f 2 -d ',')

  # id 컬럼이 셸 변수 match_id로 지정한 id와 일치하면
  # 이름 필드 표시
  if [ "$id" -eq "$match_id" ]; then
    echo "$name"
  fi
done < "$csvfile"