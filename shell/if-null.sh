#!/bin/sh

# 102. 스크립트를 수정해서 if문 안이
# 비더라도 에러가 발생하지 않게 하기

# 데이터 파일 정의
datafile="/home/user1/myapp/sample.dat"

# 데이터 파일 존재 확인
if [ -f "$datafile" ]; then
  # 용도 변경으로 필요 없으므로 주석 처리
  # ./myapp "$datafile"

  # 빈 if문은 작성할 수 없음로 :(널 명령어) 추가
  :
else
  echo "데이터 파일이 존재하지 않습니다: $datafile" >&2
  exit 1
fi