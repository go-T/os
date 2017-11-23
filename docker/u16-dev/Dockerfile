## docker build --tag=u16-dev --rm=true .
FROM u16-runtime
MAINTAINER shushengsky <shushengsky@163.com>

RUN apt-get update -y

# c++
RUN apt-get install --no-install-recommends -y \
	g++ make pkg-config 

RUN apt-get install --no-install-recommends -y \
	vim tar unzip wget curl rsync bzip2 git-core libz-dev ca-certificates \
	cmake bison yasm nasm cmake cmake-curses-gui automake  autoconf \
	jq sqlite3

RUN rm -rf /var/lib/apt/lists/
