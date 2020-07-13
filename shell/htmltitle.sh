#!/bin/sh

# 29. 여러 HTML 파일에서 title 태그만
# 추출해서 각각 다른 파일로 출력하기

# 현재 디렉터리에 있는 .html 파일이 대상
for htmlfile in *.html
do
  # 파일명에서 확장자를 뺀 문자열 취득
  fname=$(basename $htmlfile .html)

  # <title> 태그 내용을 후방참조\1로 추출, 파일 출력
  sed -n "s/^.*<title>\(.*\)<\/title>.*$/\1/p" $htmlfile > output/${fname}.txt
done
