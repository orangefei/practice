#安装mysql5.7
#软件地址：
#链接：https://pan.baidu.com/s/1I22B7R1VXR_WqUDOAUtmjw 
#提取码：5qe4 


#yum安装依赖包
yum -y install gcc gcc-c++ make cmake ncurses ncurses-devel man ncurses libxml2 libxml2-devel openssl-devel bison bison-devel
#解压boost, 5.7需要boost
cd /usr/local/src/
tar zxvf boost_1_59_0.tar.gz
mv boost_1_59_0 /usr/local

#解压cmake, 并安装
cd /usr/local/src/
tar -zxvf cmake-3.5.0.tar.gz && cd cmake-3.5.0/
./configure --prefix=/usr/local/cmake
gmake && make install

#使用cmake编译安装mysql
cd /usr/local/src/
tar -zxvf mysql-5.7.17.tar.gz && cd mysql-5.7.17/
/usr/local/cmake/bin/cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DWITH_BOOST=/usr/local/boost_1_59_0 -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
make && make install

#配置mysql
cp /etc/my.cnf /etc/my.cnf.bak
rm -rf /etc/my.cnf

#mysql初始化
cd /usr/local/mysql
useradd -r mysql
chown -R mysql .
chgrp -R mysql .

#创建数据目录
cd /usr/local/mysql
mkdir -p /usr/local/mysql/data/
bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
bin/mysql_ssl_rsa_setup --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
chown -R root .
chown -R mysql data/

#复制配置文件
cp support-files/my-default.cnf /etc/my.cnf

#使用service管理
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld

#将mysql目录加入到环境变量
cat >> /etc/profile <<EOF 
#set mysql env
PATH=/usr/local/mysql/bin:/usr/local/mysql/lib:$PATH
EOF
source /etc/profile
#修改配置文件
cat >> /etc/my.cnf <<EOF 
datadir = /usr/local/mysql/data
EOF
#启动服务并查看进程
service mysqld start
ps aux | grep mysqld

##配置主从##
cat >> /etc/my.cnf <<EOF 
# 启用二进制日志
log-bin=mysql-bin
# 服务器唯一ID
server-id=22
EOF

##重启
service mysqld restart;

##修改root密码及远程登录##
mysql

