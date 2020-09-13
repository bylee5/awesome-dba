#!/bin/sh

# 90. 늘 지정한 환경 변수를 설정해서
# 명령어를 실행하도록 래퍼 스크립트 작성하기

# TMPDIR 환경 변수 설정
TMPDIR="/disk1/tmp"
export TMPDIR

# exec 명령어로 myappd 실행. 명령행 인수를 "$@"로 넘김
exec .myappd "$@"