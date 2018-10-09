#!/bin/bash

dir=/data/app/rcs-agent-task

cd $dir
p_num=`ps -ef|grep rcs-agent-task.jar |grep -v grep |wc -l`
if [ $p_num -gt 0 ];then
   ps -ef|grep rcs-agent-task.jar |grep -v grep |awk '{print $2}' |xargs kill -9
   nohup  java -jar rcs-agent-task.jar > rcs-agent-task.log 2>&1 &
else
nohup  java -jar rcs-agent-task.jar > rcs-agent-task.log 2>&1 &
fi
