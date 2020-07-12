#!/bin/sh

# 28. 신규 파일을 만들지 않고 이미 있는
# 파일만 파일 갱신일을 바꾸기

# [YYYYMMDDhhmm.SS]로 [년월일시분.초] 지정
timestamp="201311190123.45"

# 파일 타임스탬프 갱신
# -c 옵션이 있으므로 lock 파일은 신규 파일을 만들지 않음
touch -t $timestamp app1.log
touch -c -t $timestamp lock.tmp