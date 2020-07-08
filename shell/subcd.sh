#!/bin/sh
# 25. 디렉터리 이동한 다음 간단히 원래 장소로 돌아가기

# 괄호 안은 서브셸이 되므로 디렉터리 이동은 이 안에서만 유효
(
  echo "Archive: /var/tmp/archive.tar"
  cd /var/tmp
  tar cvf archive.tar *.txt
)

# 스크립트 실행은 현재 디렉터리에서 처리
echo "Start: command.sh"
./command.sh