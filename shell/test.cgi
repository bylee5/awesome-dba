#!/bin/sh

# 64. 셸 스크립트로 CGI 실행하기

# CGI 헤더 출력
echo "Content-Type: text/plain"
echo

# 명령어를 실행해서 브라우저에 표시
echo "Test CGI: uptime"
uptime