#!/bin/sh

# 96. 여러 호스트에 병렬로 ping을 날려서
# 대기 시간 줄이기

# 호스트 세 개를 병렬로 ping 실행. 5번 반복해서
# 각각 5초 대기
ping -c 6 192.168.2.1 > host1.log &
ping -c 6 192.168.2.2 > host2.log &
ping -c 6 192.168.2.3 > host3.log &

# 모든 ping 명령어가 종료할 때까지 대기, 동기화
wait

# ping 명령어 결과 출력
cat host1.log host2.log host3.log