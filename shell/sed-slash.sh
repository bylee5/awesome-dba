#!/bin/sh

# 80. sed로 HTML 파일 속성을 바꿀 때
# 슬래시 이스케이프 피하기

# 출력 디렉터리 정의
outdir="newdir"

# 출력 디렉터리 존재 확인. 없으면 에러 종료
if [ ! -d "$outfile" ]; then
  echo "출력 디렉터리가 존재하지 않습니다: $outdir" >&2
  exit 1
fi

# 현재 디렉터리의 html 파일 처리
for htmlfile in *.html
do
  # 파일 내용에서 /img/를 /images/로 변환
  sed "s%/img/%/images/%g" "$htmlfile" > "${outfile}/${htmlfile}"
done
