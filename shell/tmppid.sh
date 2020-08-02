#!/bin/sh

# 49. 이중 실행이 가능한 임시 파일 작성하기

tmpfile="tmp.$$"

date > $tmpfile
sleep 10

cat $tmpfile
rm -f $tmpfile