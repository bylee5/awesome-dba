#!/bin/sh

# 123. 로그 출력을 감시해서 로그에
# 특정 문자열이 있으면 경고하기

# 감시 대상 로그 파일명 설정
logfile="/var/log/myapp/application.log"

# tail 명령어로 로그 감시 :
# * -F 실시간 감시
# * -n 0 추가분만 표시
tail -F -n 0 "$logfile" |\
whiel read line
do
  # 로그에서 일치하는 문자열이 있으면 경고 출력
  case "$line" in
    *"File Not Found"*)
      echo "!주의! 파일을 찾지 못했습니다 : $line"
      ;;
    *"Application Error"*
      echo "!경고! 애플리케이션 이상 : $line"
      ;;
  esac
done