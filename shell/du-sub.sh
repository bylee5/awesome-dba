#!/bin/sh

# 45. 디렉터리에 있는 서브디렉터리들의
# 디스크 사용량 조사하기

data_dir="/home/user1/myapp/data"

# $data_dir 디렉터리의 서브디렉터리 용량 표시
du -sk ${data_dir}/*/ | sort -rn