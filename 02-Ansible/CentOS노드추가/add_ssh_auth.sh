#! /usr/bin/env bash

sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.11
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.12
sshpass -p vagrant ssh -T -o StrictHostKeyChecking=no vagrant@192.168.56.13

# 스트릭트 호스트 키 체킹은 핑거프린트 예스 노 묻지 않는다는거
# 처음 셋팅 할 때부터 known hosts에 핑거프린트 동의 없이 바로 상호간의 접속 인증을 하려고 하는 것
# 이게 노드가 몇개 수준이면 상관없는데 몇십 몇백 수준으로 불어나면 시간이 많이 걸린다
# sshpass로 바로 키 받으려고 하는 거
