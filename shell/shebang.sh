#!bin/sh

# 70. 파일 앞머리의 셔뱅을 추출해서 스크립트에 따라 확장자 붙이기

# 대상 스크립트 파일이 있는지 확인
if [ ! -f "$1" ]; then
  echo "지정한 파일을 찾지 못했습니다: $1" >&2
  exit 1
fi

# 파일 첫 줄 읽기
headline=$(head -n 1 "$1")

# 파일 첫 줄에 따라 확장자를 판정해서 부여함
case "$headline" in
  */bin/sh|*bash*)
    mv -v "$1" "${1}.sh"
  ;;
  *perl*)
    mv -v "$1" "${1}.pl"
    ;;
  *ruby*)
    mv -v "$1" "${1}.rb"
    ;;
  *)
    echo "Unknown Type: $1"
esac