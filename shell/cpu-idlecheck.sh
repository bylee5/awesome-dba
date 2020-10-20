#!/bin/sh

# 118. cpu 사용률 감시하기

# 감시할 cpu %idle 허용값. 이 값 이하면 경고
idle_limit=10.0

# cpu $idle을 mpstat 명령어로 취득, 마지막 줄의 평균값을 추출
cpu_idle=$(mpstat 1 5 | tail -n 1 | awk '{print $NF}')

# 현재 %idle과 허용값을 bc 명령어로 비교
is_alert=$(echo "$cpu_idle < $idle_limit" | bc)

# 경고할 것인지 판별
if [ "$is_alert" -eq 1 ]; then
  # 현재 시각을 [2013/02/01 13:15:44] 형태로 조합
  date_str=$(date '+%Y/%m/%d %H:%M:%S')

  # cpu %idle 저하를 경고로 출력
  echo "[$date_str] cpu %idle alert: $cpu_idle (%)"
  /home/user1/bin/alert.sh
fi