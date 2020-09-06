#!/bin/sh

# 76. 로그 파일 컬럼 위치를 바꿔서
# 출력하고 보기 쉽게 바꾸기

# 로그 파일이 존재하지 않으면 종료
if [ ! -f "$1" ]; then
  echo "대상 로그 파일이 존재하지 않습니다: $1" >&2
  exit 1
fi

# 리퀘스트 시각과 원격 호스트를 외부 파일에 출력
awk '{print $4,$5$1}' "$1" > "${1}.lst"