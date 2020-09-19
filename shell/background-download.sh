#!/bin/sh

# 95. 여러 URL 파일을 동시에 병렬로 내려받기

# 병렬로 여러 사이트에서 내려받기
# 각각 백그라운드에서 처리
curl -sO http://www.example.org/download/bigfile.dat &
curl -sO http://www.example.com/files/sample.pdf &
curl -sO http://jp.example.net/images/large.jpg &