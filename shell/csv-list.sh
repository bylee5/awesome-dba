#!/bin/sh

# 73. CSV 파일에 ID 목록을 입력해서
# 대응하는 ID 컬럼값 얻기

# data.csv
# 0001,Kim,45
# 0002,Lee,312
# 0003,Park,102

# id.lst
# 0003

filecheck()
{
  if [ ! -f "$1" ]; then
    echo "ERROR: File $1 does not exist." >&2
    exit 1
  fi
}
# CSV 파일명과 ID 목록 파일명을 지정해서
# 파일 존재 확인
csvfile="data.csv"
idlistfile="$1"
filecheck "$csvfile"

filecheck "$idlistfile"

while IFS=, read id name score
do
  grep -xq "$id" "$idlistfile"
  if [ $? -eq 0 ]; then
    echo $name
  fi
done < "$csvfile"
