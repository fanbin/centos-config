#!/bin/bash




echo -n "[open ssh]-> (port)"
read ans;
port=$ans
if [ -z $ans ]; then
    port=22
fi
sub/ssh.sh $port



echo -n "[change repos]-> (y/n)?"
read ans
if [ "$ans" == "y" ]; then
sub/repo.sh
fi



echo -n "[INSTALL Components]"
sub/com.sh


echo -n "[INSTALL CMAKE]-> (y/n)?"
read ans
yum -y install tbb tbb-devel wget zsh cmake boost boost-devel



echo "[INSTALL RUBY]"
yum -y install ruby rubygem rails ruby-devel
gem sources --remove https://rubygems.org/
gem sources -a https://ruby.taobao.org
gem install bundler -V


echo "[INSTALL GIT]"
yum -y install git 
