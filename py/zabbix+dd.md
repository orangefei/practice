

一，申请钉钉账号，登录账号。
二，创建一个告警群组，添加一个机器人。
三，脚本配置
在/usr/local/zabbix/share/zabbix/alertscripts目录下面创建脚本，名称为zabbix_dingding.py
[root alertscripts]# chmod +x zabbix_dingding.py 
[root alertscripts]# ll
total 4
-rwxr-xr-x 1 zabbix zabbix 933 Aug 17 10:05 zabbix_dingding.py
[root alertscripts]# ./zabbix_dingding.py test
{"errmsg":"ok","errcode":0}
报错无request 请安装：yum install python-requests
四. Zabbix监控界面设置
1) 创建报警媒介.  三个参数分别是:{ALERT.SENDTO}      {ALERT.SUBJECT}      {ALERT.MESSAGE}
2) 用户添加报警媒介
收件人是钉钉上的手机号码.这里使用Admin管理员用户,在Admin用户的"报警媒介"里添加收件人信息
特别注意:这里只需要添加钉钉群里的任何一个成员的手机号码即可,即添加一个收件人,这样在机器人群里成员都能看到告警信息.
如果添加多个收件人,则机器人群里就会发送多个告警信息,一个收件人发一条信息.
3) 添加动作
动作里的报警信息和恢复信息都发送给Admin用户.
操作
默认接收人:{TRIGGER.STATUS}: {TRIGGER.NAME}
默认信息:
告警主机：{HOST.NAME}
主机IP： {HOST.IP}
告警时间：{EVENT.DATE} {EVENT.TIME}
告警等级：{TRIGGER.SEVERITY}
告警信息：{TRIGGER.NAME}
问题详情：{ITEM.NAME}:{ITEM.VALUE}
当前状态: {TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID： {EVENT.ID}
 
恢复操作(确认操作也是一样):
默认接收人:{TRIGGER.STATUS}: {TRIGGER.NAME}
默认信息:
告警主机：{HOST.NAME}
主机IP： {HOST.IP}
告警时间：{EVENT.DATE} {EVENT.TIME}
告警等级：{TRIGGER.SEVERITY}
告警信息：{TRIGGER.NAME}
问题详情：{ITEM.NAME}:{ITEM.VALUE}
当前状态: {TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID： {EVENT.ID}

确认操作
默认接收人:{TRIGGER.STATUS}: {TRIGGER.NAME}
默认信息:
告警主机：{HOST.NAME}
主机IP：  {HOST.IP}
告警时间：{EVENT.DATE} {EVENT.TIME}
告警等级：{TRIGGER.SEVERITY}
告警信息：{TRIGGER.NAME}
问题详情：{ITEM.NAME}:{ITEM.VALUE}
当前状态: {TRIGGER.STATUS}:{ITEM.VALUE1}
事件ID：  {EVENT.ID}
note：操作 恢复都要添加发送的用户和用户组
4）测试
比如关闭一台被监控机器的10050端口,过一会儿,查看下钉钉上的报警信息（告警和恢复）
