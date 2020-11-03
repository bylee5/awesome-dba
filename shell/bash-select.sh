#!/bin/bash

# 131. 간단한 메뉴를 표시해서 사용자가 선택할 수 있게 하기

# 메뉴 프롬프트 정의
PS3='Menu: '

# 메뉴 표시 정의. 메뉴 각 항목은 in에 목록으로 지정
# $time은 선택한 목록 문자열이, $REPLY에는 입력한 숫자가 대입됨
select item in "list file" "current directory" "exit"
do
  case "$REPAY" in
    1)
      ls
      ;;
    2)
      pwd
      ;;
    3)
      exit
      ;;
    *)
      echo "Error: Unknown Command"
      ;;
  esac

  echo
done