#!/bin/sh

# 46. 작업 파일을 만들 때 내용을
# 읽지 못하도록 보안 대책 세우기

umask 077

# echo 명령어 출력을 권한 600인 임시 파일로 작성
echo "ID: abcd123456" > idinfo.tmp