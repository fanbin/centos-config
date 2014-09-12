#!/bin/bash


yum -y group install "Development Tools" 

yum -y install python python-devel python-pip

mkdir -p ~/.pip
cat >~/.pip/pip.conf <<EOF
[global]
index-url=http://mirrors.aliyun.com/pypi/simple/
download_cache=~/.cache/pip
[install]
use-mirror=true
mirrors=http://mirrors.aliyun.com/pypi/simple/
EOF

