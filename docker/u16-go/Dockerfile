## docker build --tag=u16-go --rm=true .
FROM u16-dev
MAINTAINER shushengsky <shushengsky@163.com>

ENV GOLANG_VERSION 1.8.3
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

# depends
RUN apt-get update -y && \
	apt-get install --no-install-recommends -y graphviz git-core ca-certificates
RUN rm -rf /var/lib/apt/lists/

# rebuild go
RUN wget -q --no-check-certificate -O /tmp/go.tgz \
		http://distribute.sng.megvii-inc.com/pkgs/go1.8.3.linux-amd64.tar.gz && \
	tar -C /usr/local -xzf /tmp/go.tgz && \
		tar -C /usr -xzf /tmp/go.tgz && \
	rm /tmp/go.tgz && \
		cd /usr/local/go/src && \
		GOROOT_BOOTSTRAP=/usr/go ./make.bash && \
		rm -rf /usr/go

# gopath
RUN mkdir -p $GOPATH

# gotools
RUN go get -v -u github.com/kardianos/govendor && \
	go get -v -u github.com/google/pprof && \
	go get -v -u github.com/go-T/hey && \
	go get -v -u github.com/go-T/fileserver && \
	go get -v -u github.com/go-T/simpleserver && \
	go get -v -u github.com/thinxer/wscat && \
	rm -rf $GOPATH/src/

RUN	go get -v github.com/Sirupsen/logrus && \
	go get -v github.com/stretchr/testify/assert && \
	go get -v github.com/gorilla/websocket && \
	go get -v github.com/gorilla/mux && \
	go get -v github.com/gorilla/handlers
