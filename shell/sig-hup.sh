#!/bin/sh

# 88. HUP 시그널을 받아서 실행 중에
# 실정 파일을 다시 읽어들이기

# 환경 초기화 셸 함수. 로그 출력할 것을 설정한 setting.conf 읽음
loadconf() {
  . ./setting.conf
}

# HUP 시그널로 설정을 다시 읽도록 정의
trap 'loadconf' HUP

# 첫 초기화
loadconf

# 무한 반복
while :
do
  # uptime 명령어 결과를 setting.conf로 지정한 경로에 로그 출력
  uptime >> "${UPTIME_FILENAME}"
  sleep 1
done