#!/bin/sh

# 40. 파일 퍼미션과 타임 스탬프 등 원래 파일 속성을
# 유지한 채 파일 복사하기

backup_dir="/home/user1/backup"

# myapp 디렉터리를 $backup_dir 밑에 백업 복사
while getopts "a" option
do
  case $option in
    a)
      cp -a mysql "$backup_dir"
      exit
      ;;
  esac
done

cp -R myapp "$backup_dir"