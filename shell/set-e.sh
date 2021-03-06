#!/bin/sh

# 94. 명령어가 실패한 시점에 종료해
# 스크립트 오작동 방지하기

# 명령어 종료 스테이터스가 0이 아니라면
# 스크립트를 바로 종료하기
set -e

# 삭제 파일이 있는 디렉터리(일부러 틀림)
deldir="/var/log/myapp-"

# 디렉터리 $deldir로 이동해서 확장자가 .log인 파일 삭제
# set -e 때문에 디렉터리 이동에 실패하면 rm 명령어가 실행되지 않음
cd "$deldir"
rm -f *.log