FROM alpine:edge
MAINTAINER madsonic <support@madsonic.org>

ENV GID=1000 UID=1000
ENV JVM_MEMORY=256

# Madsonic Package Information
ENV PKG_NAME madsonic
ENV PKG_VER 6.3
ENV PKG_BUILD 9540
ENV PKG_DATE 20170703
ENV TGZ_NAME ${PKG_DATE}_${PKG_NAME}-${PKG_VER}.${PKG_BUILD}-standalone.tar.gz

WORKDIR /madsonic

RUN echo "@commuedge https://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
 && apk -U add \
    curl \
    patchelf \
    libcap \
    ffmpeg \
    openjdk8-jre@commuedge \
    tini@commuedge \
 && wget -qO- http://madsonic.org/download/${PKG_VER}/${TGZ_NAME} | tar zxf - \
 && rm -f /var/cache/apk/*

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN ln -s /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server/libjvm.so /lib/libjvm.so && \
    ln -s /usr/lib/jvm/java-1.8-openjdk/lib/amd64/jli/libjli.so /lib/libjli.so

RUN setcap cap_net_bind_service=+ep /usr/lib/jvm/default-jvm/jre/bin/java

EXPOSE 80

CMD ["/sbin/tini","--","start.sh"]
