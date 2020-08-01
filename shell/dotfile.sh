#!/bin/sh

# 48. .svn 등 숨은 파일과 디렉터리만
# 나열하기

# IFS에 줄바꿈 설정
IFS='
'

# 현재 디렉터리 아래에 있는 파일을 $filename으로 순서대로 처리
for filename in $(ls -AF)
do
  case "$filename" in
  .*/)
    echo "dot directory: $filename"
  ;;
  .*)
    echo "dot file: $filename"
  ;;
  esac
done