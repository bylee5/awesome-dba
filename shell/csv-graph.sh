#!/bin/sh

# 75. 숫자값(csv파일)에서 "*"를 써서
# 간단한 텍스트 그래프 출력하기

csvfile="data.csv" # 자료 csv 파일
GRAPH_WIDTH=50 # 그래프 너비

markprint() {
  local i=0
  while [ $i -lt $1 ]
  do
    echo -n "*"
    i=$(expr $i +1)
  done
}

# 자료에서 최댓값 얻음. 역순 정렬해서 첫 줄 얻음
max=$(awk -F, '{print $3}' "$csvfile" | sort -nr | head -n 1)

# 자료가 모두 0이면 최댓값을 1로 지정
if[ $max -eq 0 ]; then
  max=1
fi

# csv 파일을 읽어서 값마다 그래프 출력
while IFS=, read id name sorce
do
  markprint $(expr $GRAPH_WIDTH \* $score / $max)
  echo " [$name]"
done < $csvfile