## docker build --tag=u16-base --rm=true .
FROM ubuntu:16.04
MAINTAINER shushengsky <shushengsky@163.com>
# language
ENV LANG en_US.UTF-8

# apt source
RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' \
		/etc/apt/sources.list && \
	apt-get update -y && \
	apt-get install -y apt-utils language-pack-en

# timezone
RUN apt-get install -y tzdata && \
	rm -f /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

# RUN apt-cache depends xxx
# libtool > gcc
# jd > libglib2.0 libgtk2.0 ...

RUN apt-get install --no-install-recommends -y \
	vim tar unzip wget curl rsync bzip2 git-core libz-dev \
	bison yasm nasm cmake cmake-curses-gui automake make autoconf \
	pkg-config chrpath build-essential && \
	git config --global http.sslVerify false && \
	gcc -v && \
	cmake --version
