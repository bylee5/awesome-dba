#!/bin/sh

# 82. 정해진 자릿수 숫자에 하이픈 넣기
# (우편번호 등)

# 하이픈을 삭제 여부 플래그. 1이면 삭제
d_flag=0

# getopts 명령어로 삭제 옵션(-d) 판별
while getopts "d" option
do
  case $option in
    d)
      d_flag=1
      ;;
    \?)
      exit 1
      ;;
  esac
done

# 명령행 인수로 지정한 우편번호 파일을
# 셸 변수 filename에 대입
shift $(expr $OPTIND - 1)
filename="$1"

# 지정한 우편번호 파일 확인
if [ ! -f "$filename" ]; then
  echo "대상 파일이 존재하지 않습니다: $filename" >&2
  exit 1
fi
# d_flag가 지정되면 하이픈 삭제. 아니면 하이픈 추가
if [ "$d_flag" -eq 1 ]; then
  # *하이픈 삭제
  # awk로 앞뒤 공백 제거 -> 포맷 확인 -> 하이픈 삭제
  awk '{print $1}' "$filename" | grep '^[0-9]\{3\}-[0-9]]\{4\}$' | sed "s/-//"
else
  # *하이픈 추가
  # awk로 앞뒤 공백 제거 -> 포맷 확인 -> 하이픈 추가
  awk '{print $1}' "$filename" | grep '^[0-9]\{7\}$' | sed "s/\(...\)/\1-/"
fi