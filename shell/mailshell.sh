#!/bin/bash
#0 8 * * * /bin/bash -x  /data/tmp/yewu_monitor/zhngcc/huiyuan/huiyuan2.sh > "/data/tmp/yewu_monitor/zhngcc/huiyuan/log/run_cron_$(date +"\%Y-\%m-\%d-\%H").log" 2>&1 
timestamp=` date "+%Y%m%d" `
D_time=` date +%Y%m%d --date="-15 day" `

myconn="mysql -uroot  -pRdLy0 -h127.0.0.1 --default-character-set=utf8  -Dtest -H"

result_fl1=huiyuan.${timestamp}.html
D_fl=huiyuan.${D_time}.html

dir=/data/tmp/yewu_monitor/zhngcc/huiyuan

cd $dir
$myconn < ./huiyuan.sql > $result_fl1



if [ -s $result_fl1 ]; then  
	 cat $result_fl1 | mutt  -s  "zh [ $timestamp ]会员检测" -e "set content_type=text/html" xxxxxx@qq.com
fi

rm ${D_fl} -rf

exit 0


