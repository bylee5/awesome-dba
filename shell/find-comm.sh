#!/bin/sh

# 44. 두 디렉터리를 비교해서 한쪽에만 있는
# 파일 표시하기

# 비교할 디렉터리명
dirA="dir1"
dirB="dir2"

# dir1/과 dir2/ 파일 목록 차이를 조사하기
( cd dir1; find . -maxdepth 1 -type f -print | sort ) > dir1-file.lst
( cd dir2; find . -maxdepth 1 -type f -print | sort ) > dir2-file.lst

comm dir1-file.lst dir2-file.lst