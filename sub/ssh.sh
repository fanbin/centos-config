#!/bin/bash

port=$1
echo "--->>> open ssh to port:$port"
sed -i "/#Port/c\Port $port" /etc/ssh/sshd_config
firewall-cmd --zone=public --add-port=$port/tcp --permanent
firewall-cmd --reload
service sshd restart
