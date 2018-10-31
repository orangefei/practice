Docker镜像仓库Harbor之搭建及配置
目录
Harbor介绍
环境、软件准备
Harbor服务搭建
FAQ
1、Harbor 介绍
Docker容器应用的开发和运行离不开可靠的镜像管理，虽然Docker官方也提供了公共的镜像仓库，但是从安全和效率等方面考虑，部署我们私有环境内的Registry也是非常必要的。Harbor是由VMware公司开源的企业级的Docker Registry管理项目，它包括权限管理(RBAC)、LDAP、日志审核、管理界面、自我注册、镜像复制和中文支持等功能。
Harbor是一个基于docker registry v2为基础的一个带Web UI 界面的docker仓库管理工具，它具备docker 镜像管理、用户权限分配、日志监控等。
2、环境、软件准备
本次演示环境，我是在虚拟机Linux Centos7上操作，以下是安装的软件及版本：
Docker：version 1.12.6
Docker-compose： version 1.13.0
Harbor： version 1.1.2
注意：Harbor的所有服务组件都是在Docker中部署的，所以官方安装使用Docker-compose快速部署，所以我们需要安装Docker、Docker-compose。由于Harbor是基于Docker Registry V2版本，所以就要求Docker版本不小于1.10.0，Docker-compose版本不小于1.6.0。
一、环境、软件准备
1、安装docker
yum -y install docker
systemctl enable docker.service
systemctl start docker.service
2、关闭防火墙
systemctl stop firewalld.service #停止firewall
systemctl disable firewalld.service #禁止firewall开机启动
firewall-cmd --state #查看默认防火墙状态（关闭后显示notrunning，开启后显示running）

二、安装Docker-compose
1、下载指定版本的docker-compose
    $ curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
2、对二进制文件赋可执行权限
    $ sudo chmod +x /usr/local/bin/docker-compose
3、测试下docker-compose是否安装成功
    $ docker-compose --version
    docker-compose version 1.13.0, build 1719ceb
三、Harbor 服务搭建
1）下载Harbor安装文件 
从 github harbor 官网 release 页面下载指定版本的安装包。

1、在线安装包
    $ wget https://github.com/vmware/harbor/releases/download/v1.1.2/harbor-online-installer-v1.1.2.tgz
    $ tar xvf harbor-online-installer-v1.1.2.tgz
2、离线安装包
    $ wget https://github.com/vmware/harbor/releases/download/v1.1.2/harbor-offline-installer-v1.1.2.tgz
    $ tar xvf harbor-offline-installer-v1.1.2.tgz
3、配置Harbor 
解压缩之后，目录下回生成harbor.conf文件，该文件就是Harbor的配置文件
参数	        描述
hostname	服务器的名称，如果访问UI和注册服务，需要通过这个。可以是IP地址(192.168.0.209)，或者是完整的域名（reg.youdomain.com）。不要使用localhost或者127.0.0.1，因为服务需要被其他的机器访问。
#The protocol for accessing the UI and token/notification service, by default it is http.
#It can be set to https if ssl is enabled on nginx.
ui_url_protocol = http
db_password:	mysql数据的密码。
customize_crt	on或者off。默认是on。当这个属性是on的时候，prepare脚本为registry’s token 创建私有key和根证书。如果属性是off的时候，是有key和根证书将有外部资源提供。了解更多请看《Customize Key and Certificate of Harbor Token Service》
ssl_cert	SSL证书的位置，只有当协议设置成https的时候，这个属性生效
ssl_cert_key	SSL秘钥的位置，只有当协议设置成https的时候这个属性生效。
secretkey_path	加密解密的密码文件路径
4、install
./prepare
docker-compose up -d
5、完成后
http://127.0.0.1/ 
正常访问 
用户名：admin 
密码：Harbor12345

四、部署(https)
支持HTTPS
生产环境最好由权威CA机构签发证书(免费的推荐StartSSL,可参考https://www.wosign.com/Support/Nginx.html),这里为了测试方便使用自签发的证书

创建CA证书
openssl req  -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 365 -out ca.crt
生成CSR公钥
openssl req  -newkey rsa:4096 -nodes -sha256 -keyout local.harbor.com.key  -out local.harbor.com.csr
颁发证书
openssl x509 -req -days 365 -in local.harbor.com.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out local.harbor.com.crt
部署证书
cp local.harbor.com.crt local.harbor.com.key   /data/harbor/keys/
vim /data/harbor/harbor.cfg
hostname = local.harbor.com
ui_url_protocol = https
ssl_cert = /data/harbor/keys/local.harbor.com.crt
ssl_cert_key = /data/harbor/keys/local.harbor.com.key
cd /data/harbor
./prepare  重新生成配置文件
docker-compose down
docker-compose up
通过HTTPS访问私有仓库

WebUI: https://local.harbor.com
Docker Client:
[root@hub ~]# docker login -u admin -p Harbor12345 local.harbor.com
Login Succeeded

五、排错
docker login时提示x509: certificate signed by unknown authority
解决方法: 自签名的证书不被系统信任,需要cp ca.crt /etc/docker/certs.d/local.harbor.com/, 无需重启docker
docker login -u admin -p Harbor12345 10.194.1.200
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Error response from daemon: Get https://10.194.1.200/v2/: dial tcp 10.194.1.200:443: getsockopt: connection refused
cat /etc/docker/daemon.json
添加：
{ "insecure-registries":["10.194.1.200"] }
systemctl restart docker.service
