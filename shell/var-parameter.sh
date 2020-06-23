#!/bin/sh

# 실행 시 변숫값이 비어 있을 때
# 기본 값을 정의해서 설정하기

cp largefile.tar.gz ${TMPDIR:=/tmp}
cd $TMPDIR
tar xzf largefile.tar.gz

echo "Extract files to $TMPDIR"