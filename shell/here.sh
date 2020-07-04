#!/bin/sh

# 22. 히어 도큐멘트에서 변수 확장하기 않고
# 그대로 $str처럼 표시하기
# 이 변수는 확장되지 않으므로 실제로는 사용되지 않음
str="Dummy"

CAT << 'EOT'
여기는 히어 도큐먼트 본체입니다.
이 부분에 적힌 문자열은 명령어 표준 출력에
직접 리다이렉트됩니다.

종료 문자열을 작은따옴표 기호로 감싸면
$str이라고 적어도 변수 확장되지 않으며
`echo abc`도 명령어 치환되지 않습니다.
EOT