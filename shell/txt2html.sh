#!/bin/sh

# 84. 텍스트 파일에서 html 파일 만들기

# html에서 이스케이프가 필요한 기호를 문자 참조로 치환
# 마지막에서 줄 끝을 <br> 태그로 치환
sed -e 's/&/\&amp;/g' \
-e 's/</\&lt;/g' \
-e 's/>/\&gt;/g' \
-e "s/'/\&#39;/g" \
-e 's/"/\&quot;/g' \
-e 's/$/<br>/' \
"$1"