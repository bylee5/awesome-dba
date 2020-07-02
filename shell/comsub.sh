#!/bin/sh

# 20. 명령어 출력 결과를 파일명에 포함해서
# 그 파일명을 대상으로 명령어를 실행할 때 보기 쉽게 하기
err_count=$(grep -c "ERROR" /var/log/myapp/$(hostname).log)
echo "Error counts: $err_count"