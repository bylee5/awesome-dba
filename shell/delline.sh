#!/bin/sh

# 83. 파일 크기를 줄이기 위해 자바스크립트 파일에서
# 빈 줄 제거하기

# 변환 파일 출력용 디렉터리명
outdir="newdir"

# 파일 출력용 디렉터리 확인
if [ ! -d "$outdir" ]; then
  echo "Not a directory: $outdir"
  exit 1
fi

for filename in *.js
do
  # 빈 줄 또는 스페이스나 탭 문자만 있는 줄을 sed 명령어 d로 삭제
  sed '/^[[:blank:]]*$/d' "$filename" > "${outdir}/${filename}"
done