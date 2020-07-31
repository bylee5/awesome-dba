#!/bin/sh

# 47. 바이너리 파일이 포함된 문자열 얻기

# 검색할 에러 메시지
message="Unknown Error"

strings -f /home/user1/myapp/bin/* | grep "$message"