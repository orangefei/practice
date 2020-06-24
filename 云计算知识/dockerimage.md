```python
#docker构建镜像并启动容器
1.创建一个dockerfile文件
# 该镜像需要依赖的基础镜像
FROM java:8
# 将当前目录下的jar包复制到docker容器的/目录下
ADD springweb-0.0.1-SNAPSHOT.jar /mall-docker-springboot.jar
# 运行过程中创建一个mall-tiny-docker-file.jar文件
RUN bash -c 'touch /mall-docker-springboot.jar'
# 声明服务运行在8080端口
EXPOSE 8189
# 指定docker容器启动时运行jar包
ENTRYPOINT ["java", "-jar","/mall-docker-springboot.jar"]
# 指定维护者的名字
MAINTAINER xxxx

2.在liunx下可以直接创建文件写入上面配置内容
3.或者在idea中创建dockerfile,推荐安装插件docker-integration
4.直接打包为jar文件
5.上传jar包及dockerfile文件
6.构建镜像
docker build -t springweb:0.0.1 .

7.启动镜像为容器
docker run --name springweb -p 8189:8080 -d 7e193671fe27
-p 为指定端口
-d 后台运行
--name 命名容器
-e 指定参数，如数据库:用户名及密码
fd52cae048b0 为镜像ID

8.进入容器
docker exec -it 55f8e89c9bfb /bin/bash

9.运行容器试
docker pull harbor.dhtest/test/crfcredit:test2
docker run -d -p 8090:8080  harbor.dhtest/test/crfcredit:test2
docker ps -a
docker exec -it fe8f214329c6 /bin/bash

10.上传到ali
docker pull  nuaays/tomcat:8.0.51-jdk1.8.0_202
docker login --username=1301800@163.com registry.cn-hangzhou.aliyuncs.com
docker images |grep tomcat
docker tag 9058c248243a registry.cn-hangzhou.aliyuncs.com/basenv/tomjdk8:0.1
docker push registry.cn-hangzhou.aliyuncs.com/basenv/tomjdk8:0.1
docker run --name springweb -p 8189:8080 -d 7e193671fe27

11.删除镜像
已运行的(CONTAINER ID)
docker ps -a
docker stop e71f5c866c29
docker rm e71f5c866c29
静态的(IMAGE ID)
docker images
docker image rm -f d2e39803f671

12.jdktom8 镜像 
ROM registry.cn-hangzhou.aliyuncs.com/basenv/tomjdk8:0.4
MAINTAINER war
Run ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
Run echo 'Asia/Shanghai' >/etc/timezone
COPY  ./fcp2intra.war /usr/local/tomcat/webapps/
EXPOSE 8080

```

