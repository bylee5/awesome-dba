#!/bin/sh

# 23. 절대 경로, 상대 경로 관계없이
# 같은 동작하기
cd "$(dirname "$0")"

./start.sh
./end.sh