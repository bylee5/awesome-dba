#!/bin/sh

# 파일을 읽어서 처리할 때 키보드에서 입력받기

tty=`tty`
while read question
do
  echo $question
  read dir < $tty
  echo "Command: ls $dir"
  ls $dir
done < question.txt