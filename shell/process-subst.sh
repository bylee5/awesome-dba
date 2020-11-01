#!/bin/bash

# 129. 중간 파일 없이 명령어 출력을 파일처럼 다루기

# 비교할 두 디레거리 정의
dir1="/var/tmp/backup1"
dir2="/var/tmp/backup2"

# comm 명령어로 출력을 비교. 중간 파일을 만들지 않아도
# 프로세스 치환으로 처리 가능
comm <(ls "$dir1") <(ls "$dir2")
