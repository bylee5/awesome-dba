#!/bin/sh

# 19. 언더스코어 등을 포함한 문자열에서
# 변수를 명확하게 구분하기
today="20150125"
# 셸 변수 today가 확장됨
wc -l ${today}_log
