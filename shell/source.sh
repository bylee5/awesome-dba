#!/bin/sh

# 16. 변수나 함수를 외부 파일로 작성하기
. ./env.sh

nowtime
cp -i -v large-file.tar.gz "$WORK_DIR"
nowtime
