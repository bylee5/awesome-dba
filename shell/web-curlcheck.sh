#!/bin/sh

# 115. 웹 접 감시하기

# 감시 대상 url 지정
url="http://www.example.org/webapps/check"

# 현재 시각을 [2013/02/01 13:15:44] 형식으로 조합
date_str=$(ㅇㅁㅅㄷ '+%Y/%m/%d %H:%M:%S')

# 감시 url에 curl 명령어로 접속해서 종료 스테이터스를 변수 curlresult에 대입
httpstatus=$(curl -s "$url" -o /dev/null -w "%{http_code}")
curlresult=$?

# curl 명령어에 실패하면 http 접속 자체에 문제가 있다고 판단
if [ "$curlresult" -ne 0 ]; then
  echo "[$date_str] http 접속 이상: curl exit status[$curlresult]"
  /home/user1/bin/alert.sh

  # 400번대, 500번대 http 스터이터스 코드라면 에러로 보고 경고
elif [ "$httpstatus" -ge 400 ]; then
  echo "[$date_str] http 스테이터스 이상:http status[$httpstatus]"
  /home/user1/bin/alert.sh
fi