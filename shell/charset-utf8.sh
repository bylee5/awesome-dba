#!/bin/sh

# 85. html 파일 문자 코드를 자동으로
# 판별해서 utf-8로 인코딩된 파일로 바꾸기

# 변환한 파일을 출력할 디렉터리
outdir="newdir"

# 파일 출력용 디렉터리 확인
if [ ! -d "$outdir" ]; then
  echo "Not a directory: $outdir"
  exit 1
fi

# 현재 디렉털의 .html 파일이 대상
for filename in *.html
do
  # grep 명령어로 meta 태그 content-type을 선택해서
  # sed 명령어로 charset= 지정 부분 추출
  charset=$(grep -i '<meta ' "$filename" |\
  grep -i 'http-equiv="Content-Type"' |\
  sed -n 's/.*charset=\([-_a-zA-Z0-9]*\).*/\1/p')

  # charset을 얻지 못하면 iconv 명령어를 실행하지 않고 건너뛰기
  if [ -z "$charset" ]; then
    echo "charset not found: $finename" >&2
    continue
  fi

  # meta 태그에서 추출한 문자 코드에서 utf-8으로 변환
  # 디렉터리 $outdir에 출력
  iconv -c -f "$charset" -t UTF-8 "filename" > "${outdir}/${filename}"
done