#!/bin/sh

# 지역 변수를 함수 안에 정의해서
# 호출한 곳의 변수가 파괴되지 않게 하기

DIR=/var/tmp

ls_home()
{
  # 변수 DIR을 함수 내부 변수로 정의
  local DIR

  DIR=~/$1
  echo "directory: $DIR"
  ls $DIR
}

ls_home logdir

echo "directory: $DIR"
ls $DIR