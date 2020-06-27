#!/bin/sh

# 15. 작은따옴표 안에서 작은따옴표 쓰기
price=100
str='It costs $'$price'? I can'\''t believe it!'
echo $str
