#!/bin/bash
#########################################
#Function: update yum source
#Usage: bash update_yum_source.sh
#Author: Customer service department
#Company: Alibaba Cloud Computing
#Version: 2.1
#########################################
check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] || [ "$os_release_2" ]
    then
      echo "$os_release_2"
      break
    fi
    os_release=$(grep "CentOS" /etc/issue 2>/dev/null)
    os_release_2=$(grep "CentOS" /etc/*release 2>/dev/null)
    if [ "$os_release" ] || [ "$os_release_2" ]
    then
      echo "$os_release_2"
      break
    fi
    break
  done
}

modify_rhel7_yum_aliyun()
{

  rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
  cd /etc/yum.repos.d/
  curl http://mirrors.aliyun.com/repo/Centos-6.repo -o CentOS-Base-aliyun.repo
  sed -i '/mirrorlist/d' CentOS-Base-aliyun.repo
  sed -i '/\[addons\]/,/^$/d' CentOS-Base-aliyun.repo
  sed -i 's/\$releasever/7/' CentOS-Base-aliyun.repo
  sed -i 's/RPM-GPG-KEY-CentOS-6/RPM-GPG-KEY-CentOS-7/' CentOS-Base-aliyun.repo
  yum clean metadata
  yum makecache
  cd ~
}

modify_epel7_yum_aliyun()
{

  rpm --import http://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-7
  cd /etc/yum.repos.d/
  curl http://mirrors.aliyun.com/repo/epel-6.repo -o CentOS-epel-aliyun.repo
  sed -i '/mirrorlist/d' CentOS-epel-aliyun.repo
  sed -i '/\[addons\]/,/^$/d' CentOS-epel-aliyun.repo
  sed -i 's/6/7/' CentOS-epel-aliyun.repo
  sed -i 's/RPM-GPG-KEY-EPEL-6/RPM-GPG-KEY-EPEL-7/' CentOS-epel-aliyun.repo
  yum clean metadata
  yum makecache
  cd ~
}


#

modify_rhel6_yum_aliyun()
{
  rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6
  cd /etc/yum.repos.d/
  curl http://mirrors.aliyun.com/repo/Centos-6.repo -o CentOS-Base-aliyun.repo
  sed -i '/mirrorlist/d' CentOS-Base-aliyun.repo
  sed -i '/\[addons\]/,/^$/d' CentOS-Base-aliyun.repo
  sed -i 's/\$releasever/6/' CentOS-Base-aliyun.repo
  sed -i 's/RPM-GPG-KEY-CentOS-6/RPM-GPG-KEY-CentOS-6/' CentOS-Base-aliyun.repo
  yum clean metadata
  yum makecache
  cd ~
  
}

##########start######################
#check lock file ,one time only let the script run one time
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\n\033[0m"
  rm -rf $LOCKfile
  exit 1
fi

os_type=$(check_os_release)
#echo $os_type
if [ "X$os_type" == "X" ]
then
  echo -e "\033[1;40;31mOS type is not RedHat or CentOS, script will no execute.\n\033[0m"
  rm -rf $LOCKfile
  exit 0
else
  echo -e "\033[40;32mOS is $os_type.\033[40;37m"
  echo "$os_type" |grep 7 >/dev/null
  if [ $? -eq 0 ]
  then
    modify_rhel7_yum_aliyun
    modify_epel7_yum_aliyun 
    rm -rf $LOCKfile
    exit 0
  fi
fi
rm -rf $LOCKfile
