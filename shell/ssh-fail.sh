#!/bin/sh

# 78. 시스템 로그에서 ip 주소마다
# 횟수 집계하기

# sshd 로그 파일
securelog="/var/log/secure"

# ip 주소를 추출하기 위한 패턴. 변수에 저장
pattern="^.*sshd\[.*\].*Failed password for.* from \(.*\) port .*"

# 암호 인증 실패 로그에서 ip 주소를 추출, 카운트해서 표시
sed -n "s/$pattern/\1/p" "$securelog" | sort | uniq -c | sort -nr