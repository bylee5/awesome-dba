#!/bin/sh

# 119. 웹 페이지 변경 감시하기

# 감시 대상 url
url="http://www.example.org/update.html"

# 내려받기 파일명 정의
newfile="new.bat"
oldfile="old.bat"

# 파일 내려받기
curl -so "$newfile" "$url"

# 이전에 내려받은 파일과 curl로 내려받은 파일 비교
cmp -s "$newfile" "$oldfile"

# cmp 명령어 종료 스테이터스가 0이 아니면 차이가 존재
if [ $? -ne 0 ]; then
  # 현재 시각을 2013/02/01 13:15:44 형태로 조합
  date_str=$(date '+%Y/%m/%d %H:%M:%S')
  # 파일 변경 알림
  echo "[$date_str] 파일이 변경되었습니다."
  echo "대상 url: $url"
  /home/user1/bin/alert.sh
fi

# curl에서 내려받은 파일을 파일명을 변경해서 저장
mv -f "$newfile" "$oldfile"