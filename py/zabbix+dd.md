

һ�����붤���˺ţ���¼�˺š�
��������һ���澯Ⱥ�飬���һ�������ˡ�
�����ű�����
��/usr/local/zabbix/share/zabbix/alertscriptsĿ¼���洴���ű�������Ϊzabbix_dingding.py
[root alertscripts]# chmod +x zabbix_dingding.py 
[root alertscripts]# ll
total 4
-rwxr-xr-x 1 zabbix zabbix 933 Aug 17 10:05 zabbix_dingding.py
[root alertscripts]# ./zabbix_dingding.py test
{"errmsg":"ok","errcode":0}
������request �밲װ��yum install python-requests
��. Zabbix��ؽ�������
1) ��������ý��.  ���������ֱ���:{ALERT.SENDTO}      {ALERT.SUBJECT}      {ALERT.MESSAGE}
2) �û���ӱ���ý��
�ռ����Ƕ����ϵ��ֻ�����.����ʹ��Admin����Ա�û�,��Admin�û���"����ý��"������ռ�����Ϣ
�ر�ע��:����ֻ��Ҫ��Ӷ���Ⱥ����κ�һ����Ա���ֻ����뼴��,�����һ���ռ���,�����ڻ�����Ⱥ���Ա���ܿ����澯��Ϣ.
�����Ӷ���ռ���,�������Ⱥ��ͻᷢ�Ͷ���澯��Ϣ,һ���ռ��˷�һ����Ϣ.
3) ��Ӷ���
������ı�����Ϣ�ͻָ���Ϣ�����͸�Admin�û�.
����
Ĭ�Ͻ�����:{TRIGGER.STATUS}: {TRIGGER.NAME}
Ĭ����Ϣ:
�澯������{HOST.NAME}
����IP�� {HOST.IP}
�澯ʱ�䣺{EVENT.DATE} {EVENT.TIME}
�澯�ȼ���{TRIGGER.SEVERITY}
�澯��Ϣ��{TRIGGER.NAME}
�������飺{ITEM.NAME}:{ITEM.VALUE}
��ǰ״̬: {TRIGGER.STATUS}:{ITEM.VALUE1}
�¼�ID�� {EVENT.ID}
 
�ָ�����(ȷ�ϲ���Ҳ��һ��):
Ĭ�Ͻ�����:{TRIGGER.STATUS}: {TRIGGER.NAME}
Ĭ����Ϣ:
�澯������{HOST.NAME}
����IP�� {HOST.IP}
�澯ʱ�䣺{EVENT.DATE} {EVENT.TIME}
�澯�ȼ���{TRIGGER.SEVERITY}
�澯��Ϣ��{TRIGGER.NAME}
�������飺{ITEM.NAME}:{ITEM.VALUE}
��ǰ״̬: {TRIGGER.STATUS}:{ITEM.VALUE1}
�¼�ID�� {EVENT.ID}

ȷ�ϲ���
Ĭ�Ͻ�����:{TRIGGER.STATUS}: {TRIGGER.NAME}
Ĭ����Ϣ:
�澯������{HOST.NAME}
����IP��  {HOST.IP}
�澯ʱ�䣺{EVENT.DATE} {EVENT.TIME}
�澯�ȼ���{TRIGGER.SEVERITY}
�澯��Ϣ��{TRIGGER.NAME}
�������飺{ITEM.NAME}:{ITEM.VALUE}
��ǰ״̬: {TRIGGER.STATUS}:{ITEM.VALUE1}
�¼�ID��  {EVENT.ID}
note������ �ָ���Ҫ��ӷ��͵��û����û���
4������
����ر�һ̨����ػ�����10050�˿�,��һ���,�鿴�¶����ϵı�����Ϣ���澯�ͻָ���
