#!/bin/sh

# 18. HTML 파일에서 태그 속에 적힌 주석을
# 추출해서 그대로 실행하기
filename="myapp.log"
eval $(sed -n "s/<code>\(.*\)<\/code>/\1/p" command.html)