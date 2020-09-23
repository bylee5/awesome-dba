#!/bin/sh

# 99. 연속된 파일명을 가진 url을 자동 생성해서
# 순서대로 내려받기

url_template=http://www.example.org/download/img_%03d.jpg

# sed 명령어로 연속 번호 생성
for i in $(seq 10)
do
  url=$(printf "$url_template" $i)
  curl -O "$url"
done