FROM debian:buster as buildenv

ARG DASH_VERSION="v0.5.11.2"

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
     automake=1:1.16.1-4 \
     ca-certificates=20200601~deb10u1 \
     gcc=4:8.3.0-1 \
     git=1:2.20.1-2+deb10u3 \
     libc6-dev=2.28-10 \
     make=4.2.1-1.2 \
 && rm -rf /var/lib/apt/cache \
 && git clone https://git.kernel.org/pub/scm/utils/dash/dash.git

WORKDIR /dash

RUN git checkout "$DASH_VERSION" && \
    ./autogen.sh && \
    ./configure --enable-static && \
    make

FROM scratch
COPY --from=buildenv /dash/src/dash /bin/sh
ENTRYPOINT [ "/bin/sh" ]
