#!/bin/sh

# 93. 리다이렉트가 번잡하지 않도록
# 그룹핑해서 보기 좋게 만들기

# 중괄호로 그룹핑해서 리다이렉트를 하나로 합치기
{
  echo "[Script start]"
  date
  ls
  echo "[Script end]"
} > output.log