# -*- coding: utf-8 -*-  
"""
Created on Fri Feb  9 17:21:39 2018
func:查询Mysql结果,生成excel文件,发送到指定邮箱
@author:@benbendemo 
"""
import pandas as pd
import MySQLdb
import datetime
from email import encoders
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
import smtplib
import re

# 设置全局公共参数PGMname
PGMname = 'PGM:python_learning_send_email'

# 返回sql语句查询结果
def fetch_db(sql):

    """
    fetch_db,创建数据库连接,执行sql语句查询结果
    """
    
    # user,passwd,db参数需要自行配置
    db_user = MySQLdb.connect(host='10.195.68.4',port=3306,charset='utf8',
                              user='user_readonly',passwd='RdLy0804^slbj%2016',db='crf_rcs_agent_db') 
    cursor = db_user.cursor()
    cursor.execute("SET NAMES utf8;")
    cursor.execute(sql)
    result = cursor.fetchall()
    db_user.close()

    print "OK!!! Result Type is:",type(result)
    return result

# 将sql执行查询结果生成到excel文件
def gen_xls(res,col):

    """
    gen_xls,将数据库查询结果生成excel文件
    """

    file_name = datetime.datetime.now().strftime("%Y-%m-%d-%H-%M") + ".sql.xlsx"

    # from_records方法要求使用列表类型作为数据源,这里需要强制转换
    if type(res) is not list:
        res = list(res)
        
    # from_records方法columns参数的作用是设置数据的列名,影响head行
    df = pd.DataFrame.from_records(data=res,columns=col)

    # 输出到excel表格里面
    df.to_excel(file_name,"Sheet1",index=True,header=True)

    print "OK!!! Filename is:",file_name
    return file_name

# 将生成的excel文件发送给指定邮箱
def sendmsg(f_email,f_pwd,to_list,smtp_server,sendfile):
    """
    sendmsg,使用smtplib发送邮件,这里使用网易邮箱作为发送方
    """

    sub = '会员检测'
    content = '会员检测查询结果,生成此份Excel文件,请查收附件'

    # 邮件对象
    msg = MIMEMultipart()
    msg['From'] = f_email
    msg['Subject'] = sub  
    to_str = ''
    for x in to_list:
       to_str += x + ','        
    # msg['To']接收的参数是str而不是list或tuple,多个地址使用逗号隔开
    msg['To'] = to_str
    # 邮件正文是MIMEText
    msg.attach(MIMEText(content,'plain','utf-8'))

    with open(sendfile,'rb') as fp:

        # 设置附件的MIME类型,这里使用xls类型,application/octet-stream表示附件是下载格式
        mime = MIMEBase('application/octet-stream', 'xls', filename='sql.xlsx')
        # 添加头信息
        mime.add_header('Content-Disposition', 'attachment', filename='sql.xlsx')
        mime.add_header('Content-ID', '<0>')
        mime.add_header('X-Attachment-Id', '0')
        # 将附件内容读取为数据流
        mime.set_payload(fp.read())
        # 用Base64编码
        encoders.encode_base64(mime)
        # 添加到MIMEMultipart
        msg.attach(mime)

    try:
        server = smtplib.SMTP()
        # set_debuglevel参数设为0不打印log;设为1打印log
        server.set_debuglevel(1)
        server.connect(smtp_server,25)
        server.starttls()
        server.login(f_email,f_pwd)
        server.sendmail(f_email,to_list,msg.as_string())
        server.quit()
        print PGMname + ":" + "sendmsg" + ":" + "Send Email OK!"
    except Exception as e:
        print PGMname + ":" + "sendmsg" + ":" + "Exception!",e

# 要查询的sql语句
sql = "SELECT b.`order_no`,b.`receive_addr`,c.`user_name`, IFNULL( b.`field2`,c.`user_name`),IFNULL( b.`field1`,c.`user_phone`),b.`goods_name`, DATE(b.`insert_date`)FROM `agt_pay_flow` a ,`agt_loan_goods` b,`agt_loan_order` c WHERE c.`loan_no`=b.`loan_no` AND a.`loan_no`=b.`loan_no` AND a.`proc_status`='c' AND  a.`reverse_ind`<>'y' AND DATE_FORMAT(a.`insert_date`,'%Y-%m-%d')=DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 DAY),'%Y-%m-%d');"

# 待查询库表的列名,匹配allAstockinfo库表的列名
#col = ['order_no','receive_addr','user_name','field2','user_phone','goods_name','date']
col = ['订单编号','收货地址','订单用户名 ','收货人','收货手机号 ','商品名','日期']

# 接收邮件用户列表,换成你自己的邮箱地址
to_email = ['xxxx@qq.com']

# 查询数据库
res = fetch_db(sql)

# 将结果传给文件参数
xlsfile = gen_xls(res,col)

# pattern1只能匹配纯数字邮箱,不适用
pattern1 = "(^[1-9][0-9]{1,10})(\@)([\w0-9]+)(\.(com|org|cn)$)"
com_pattern1 = re.compile(pattern1)

# pattern2可匹配非纯数字邮箱(中间不能有两个点号或下划线连续出现的情况没有解决),pattern2包含了pattern1
pattern2 = "([\w1-9][\w0-9\_\-\.]{1,20})(\@)([\w0-9]+)(\.(com|org|cn)$)"
com_pattern2 = re.compile(pattern2)


# 输入发生邮箱密码,注意如果邮箱开启授权码验证(比如网易邮箱),则需要输入授权码作为密码
#from_email_pwd = raw_input('From_email_pwd:')
from_email = 'xxxx@qq.com'
smtp_server = 'smtp@qq.com'
from_email_pwd = 'qw12@!as'

# 发送邮件
sendmsg(from_email,from_email_pwd,to_email,smtp_server,xlsfile)
