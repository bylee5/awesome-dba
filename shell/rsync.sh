#!/bin/sh

# 34. 파일들을 다른 디렉터리에 동기화해서
# 백업처리하기

log_dir="/home/user1/myapp/log"
backup_dir="/backup/myapp"

# /home/user1/myapp/log 안에 있는 로그 파일을
# /backup/mysql/log 디렉터리에 복사
rsync -av "$log_dir" "$backup_dir"