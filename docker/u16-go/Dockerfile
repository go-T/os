## docker build --tag=u16-go --rm=true .
FROM u16-base:latest
MAINTAINER shushengsky <shushengsky@163.com>
ENV LANG en_US.UTF-8

ENV GOLANG_VERSION 1.8.3

RUN curl -s -o /tmp/go.tgz \
			https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
	tar -C /usr/local -xzf /tmp/go.tgz && \
		tar -C /usr -xzf /tmp/go.tgz && \
	rm /tmp/go.tgz && \
		cd /usr/local/go/src && \
		GOROOT_BOOTSTRAP=/usr/go ./make.bash && \
		rm -rf /usr/go && \
	export PATH="/usr/local/go/bin:$PATH" && \
	go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
