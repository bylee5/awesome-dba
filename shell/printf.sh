#!/bin/sh

# 81. 오른쪽 정렬로 숫자를 표시하는 텍스트 표 만들기

# 정렬할 문자열 정의
search_text="ERROR 19:"

# 현재 디렉터리에서 확장자가 .log인 파일을 순서대로 처리
for filename in *.log
do
  # 일치하는 줄 수를 -c 옵션으로 취득
  count=$(gerp -c "$search_text" "$filename")
  # printf 명령어로 오른쪽 정렬 6칸으로 변경해서 출력
  printf "%6s (%s)\n" "$count" "$filename"
done