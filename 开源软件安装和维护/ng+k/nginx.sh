#!/bin/bash
A=`ps -C nginx --no-header |wc -l`
if [ $A -eq 0 ];then
  /data/app/nginx/sbin/nginx #nginx命令的路径
  sleep 3
  if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
    killall keepalived
  fi
fi




