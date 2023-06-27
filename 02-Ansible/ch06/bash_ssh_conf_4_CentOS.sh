#! /usr/bin/env bash

now=$(date +"%m_%d_%Y")    # now는 변수명    $()는 명령어 이 명령어를 실행 하라는 뜻
cp /etc/ssh/sshd_config /etc/ssh/sshd_config_$now.backup
sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# 앞에 것을 뒤로 바꿔라는 것 패스워드 인증을 no에서 yes로 바꿔라는 것
systemctl restart sshd

# 앤서블 서버는 각각의 노드로 ssh로 명령을 보낸다
# 윈도우에서 앤서블 서버로는 키 인증으로 vagrant ssh로 접속 했었음
# 각 노드에는 키가 아니라 패스워드로 접속
# sed 명령으로 패스워드 인증을 no 가 아닌 yes로 만들어줌 그래야 패스워드 접속이 됨
# 그다음 시스템 리스타트 하는거
# telnet은 보안에 취약하기 때문에 앤서블 서버에서 앤서블 노드로는 ssh접속으로 하고
# ssh 통신으로 명령을 보낸다.