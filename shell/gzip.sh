#!/bin/sh

# 37. gzip 명령어로 압축률 높이기

tar cf archive.tar log

# -9 옵션으로 압축률을 최대로 함
gzip -9 archive.tar