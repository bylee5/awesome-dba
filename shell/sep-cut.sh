#!/bin/sh

# 105. 서버에 작성된 사용자 계정 목록 얻기

# 사용자 계정 정보 파일
filename="/etc/passwd"

# 줄 첫 글자가 #인 주석 줄은 제외하고 cut 명령어로
# * 첫 번째 값을 표시 [-f 1]
# * 구분자 기호는 : [-d ":"]로 표시
grep -v "^#" "$filename" | cut -f 1 -d ":"