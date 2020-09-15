#!/bin/sh

# 92. 이식성을 고려한 외부 명령어 이용하기

# echo 명령어 경로를 환경에 따라 바꿔서 셸 변 수 echo에 대입
case $(uname -s) in
  # Mac이면 셸 내장이 아니라 /bin/echo 사용
  Darwin)
    ECHO="/bin/echo"
    ;;
  *)
    ECHO="echo"
    ;;
esac

$ECHO -n "이것은 줄이 이어진"
$ECHO "메시지입니다."