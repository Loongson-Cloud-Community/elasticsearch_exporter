FROM cr.loongnix.cn/library/golang:1.19-alpine as builder

RUN apk add wget 

RUN wget https://github.com/Loongson-Cloud-Community/promu/releases/download/v0.13.0/promu-0.13.0.linux-loong64.tar.gz && \
    tar xf promu-0.13.0.linux-loong64.tar.gz && \
    chmod +x promu-0.13.0.linux-loong64/promu && \
    cp promu-0.13.0.linux-loong64/promu /usr/bin/

RUN go env -w GO111MODULE="auto" 
ADD .   /go/src/github.com/justwatchcom/elasticsearch_exporter
WORKDIR /go/src/github.com/justwatchcom/elasticsearch_exporter

RUN promu build --prefix /go/src/github.com/justwatchcom/elasticsearch_exporter

FROM        cr.loongnix.cn/library/busybox:1.30.1
MAINTAINER  qiangxuhui <qiangxuhui@loongson.cn>

COPY --from=builder /go/src/github.com/justwatchcom/elasticsearch_exporter/elasticsearch_exporter  /bin/elasticsearch_exporter

EXPOSE      9114
ENTRYPOINT  [ "/bin/elasticsearch_exporter" ]
