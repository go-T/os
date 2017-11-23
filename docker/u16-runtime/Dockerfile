## docker build --tag=u16-runtime --rm=true .
FROM ubuntu:16.04
MAINTAINER shushengsky <shushengsky@163.com>
# language
ENV LANG en_US.UTF-8

# apt source
RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list && \
	apt-get update -y && \
	apt-get install -y apt-utils language-pack-en tzdata && \
	rm -f /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata 

RUN rm -rf /var/lib/apt/lists/
