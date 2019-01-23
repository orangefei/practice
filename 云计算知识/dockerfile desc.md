
应用容器化：
基础镜像：war/jar/go

模板化：
代码包含dockerfile,yaml文件修改对应的(name app label)

思路：
代码更新后，将代码做成基础镜像并上传至harbor。然后调用yaml文件拉取最新的镜像tag,来更新代码/功能。

war/jar dockerfile

FROM docker.io/tomcat
MAINTAINER war
Run ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
Run echo 'Asia/Shanghai' >/etc/timezone
COPY  ./target/helloworld.war /usr/local/tomcat/webapps/
EXPOSE 8080

FROM anapsix/alpine-java
ADD ./target/main-0.0.1.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
#from指令指明了当前镜像的基镜像，编译当前镜像时自动下载基镜像。
#MAINTAINER指明作者
#ADD 复制jar文件到镜像中去并重命名为demo.jar
#EXPOSE暴露8080端口
#ENTRYPOINT启动时执行java -jar demo.jar



创建go的基础镜像
touch app.go
go build报错之后需要自动拉取库
go get github.com/aymerick/raymond
go get github.com/fvbock/endless
go get github.com/go-zoo/bone


启动报错原因是我们的main文件生成的时候依赖的一些库如libc还是动态链接的，但是scratch 镜像完全是空的，什么东西也不包含，所以生成main时候要按照下面的方式生成，使生成的main静态链接所有的库：
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
note：每次启动都需要go build 相当于代码更新

go语言的dockerfile制作
首先需要一个go环境go build
构建一个go的基础镜像

FROM scratch
ADD main /
RUN chmod u+x main && go build .
CMD ["/main"]
EXPOSE 4242
# 应用容器化：
## 基础镜像：war/jar/go

## 模板化：
代码包含dockerfile,yaml文件修改对应的(name app label)

## 思路：
代码更新后，将代码做成基础镜像并上传至harbor。然后调用yaml文件拉取最新的镜像tag,来更新代码/功能。

```
war/jar dockerfile

FROM docker.io/tomcat
MAINTAINER war
Run ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
Run echo 'Asia/Shanghai' >/etc/timezone
COPY  ./target/helloworld.war /usr/local/tomcat/webapps/
EXPOSE 8080

FROM anapsix/alpine-java
ADD ./target/main-0.0.1.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

#from指令指明了当前镜像的基镜像，编译当前镜像时自动下载基镜像。
#MAINTAINER指明作者
#ADD 复制jar文件到镜像中去并重命名为demo.jar
#EXPOSE暴露8080端口
#ENTRYPOINT启动时执行java -jar demo.jar
```


## 创建go的基础镜像
```
touch app.go
go build报错之后需要自动拉取库
go get github.com/aymerick/raymond
go get github.com/fvbock/endless
go get github.com/go-zoo/bone
```

启动报错原因是我们的main文件生成的时候依赖的一些库如libc还是动态链接的，但是scratch 镜像完全是空的，什么东西也不包含，所以生成main时候要按照下面的方式生成，使生成的main静态链接所有的库：

```
CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
note：每次启动都需要go build 相当于代码更新
```

go语言的dockerfile制作
首先需要一个go环境go build
构建一个go的基础镜像

```
FROM scratch
ADD main /
RUN chmod u+x main && go build .
CMD ["/main"]
EXPOSE 4242
```