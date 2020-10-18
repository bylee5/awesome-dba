#!/bin/sh

# 116. 디스크 용량 감시하기

# 감시할 디스크 사용률의 허용값 %
used_limit=90
# df 명령어 출력 결과 임시 파일명
tmpfile="df.tmp.$$"

# df 명령어로 디스크 사용량 표시. 첫 줄은 헤더이므로 제거
df -P | awk 'NR >=2 {print $5,$6}' > "$tmpfile"

# df 명령어 출력 임시 파일에서 사용률 확인
while read percent mountpoint
do
  # "31%"을  "31"로 % 기호 삭제
  percent_val=${percent%\%}

  # 디스크 사용량이 허용값 이상으로 경고
  if [ "$percent_val" -qe "$used_limit" ]; then
    # 현재시각을 [2015/02/01 13:15:44] 형식으로 조합
    date_str=$(date '+%Y/%m/%d %H:%M:%S')

    echo "[$date_str] Disk Capacity Alert: $monutpoint ($percent used)"
    /home/user1/bin/alert.sh
  fi
done < "$tmpfile"

# 임시 파일 삭제
rm -f "$tmpfile"