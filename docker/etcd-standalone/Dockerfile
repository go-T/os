FROM alpine:3.2

ENV ETCDCTL_API 3

RUN apk add --update ca-certificates openssl tar wget && \
    wget https://github.com/coreos/etcd/releases/download/v3.2.7/etcd-v3.2.7-linux-amd64.tar.gz && \
    tar xzvf etcd-v3.2.7-linux-amd64.tar.gz && \
    mv etcd-v3.2.7-linux-amd64/etcd* /bin/ && \
    apk del --purge tar openssl && \
    rm -Rf etcd-v3.2.7-linux-amd64* /var/cache/apk/*

VOLUME /data

EXPOSE 2379 2380

CMD /bin/etcd              \
    --name=etcd-standalone \
    --data-dir=/data       \
    --listen-peer-urls http://0.0.0.0:2379             \
    --listen-client-urls http://0.0.0.0:2380           \
    --advertise-client-urls http://0.0.0.0:2379        \
    --initial-advertise-peer-urls http://0.0.0.0:2380  \
    --initial-cluster-state new
