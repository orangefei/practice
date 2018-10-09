#!/bin/bash

touch /root/zengfanzhu/djangoInstallInfo.txt
/usr/bin/python /root/zengfanzhu/Django-1.6.11/setup.py install
find /{bin,lib,lib64,sbin,usr} -cnewer /root/zengfanzhu/djangoInstallInfo.txt -type f -print >> /root/zengfanzhu/djangoInstallInfo.txt
mv /root/zengfanzhu/djangoInstallInfo.txt /root/zengfanzhu/djangoInstallInfo.`date "+%Y-%m-%d-%H-%M-%S"`.txt
if [ -f "/root/zengfanzhu/djangoInstallInfo.txt" ];then
  rm "/root/zengfanzhu/djangoInstallInfo.txt"
fi
