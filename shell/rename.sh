#!/bin/sh

# 41. HTML 파일인 .htm과 .html 확장자를
# txt로 일괄 변경하기

for filename in * # * 표시로 인해 현재 디렉터리에 있는 파일명을 모두 가져온다.
do
  case "$filename" in
    *.htm | *.html)
      # 파일명 앞 부분을 취득(index)
      headname=${filename%.*}

      # 파일명을 .txt로 변환
      mv "$filename" "${headname}.txt"
    ;;
  esac
done