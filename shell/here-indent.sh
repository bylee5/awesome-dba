#!/bin/sh

# 86. 함수나 if문 같은 히어 도큐먼트를  쓸 때
# 탭 정렬로 보기 좋게 만들기

# 명령행 인수 확인
if [ -z "$1" ]; then
  echo "title을 인수로 지정하세요." >&2
  exit 1
else
  # 명령행 인수 $1 문자열을 title 요소에 넣어서 표시
  # 히어 도큐먼트에 -(하이픈)을 지정해서
  # 앞부분 탭을 무시하고 들여쓰기
  cat <<-EOT
  <html>
  <head>
    <title>$1</title>
  </head>

  <body>
    <p>Auto HTML sample.</p>
  </body>
  EOT
  # 히어 도큐먼트 부분에 있는 들여쓰기는 스페이스가 아니라 탭
fi