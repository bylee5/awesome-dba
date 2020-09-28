#!/bin/sh

# 103. 웹 서버에서 파일을 내려받아서
# md5 해시값 계산하기

# 내려받을 파일 url 경로, 파일명 지정
url_path="http://www.example.org/"
filename="sample.dat"

# 파일 내려받기. 내려받기에 성공하면 md5 해시값 표시
# mac/freeBSD라면 md5sum 명령어가 아니라 md5 명령어 사용
curl -sO "${url_path}${filename}" && md5sum "$filename"

# 내려받기 파일을 삭제하고 종료
rm -f "$filename"