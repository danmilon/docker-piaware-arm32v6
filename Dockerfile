FROM arm32v6/alpine:latest
LABEL maintainer="Dan Milon <i@danmilon.me>"
COPY qemu-arm-static /usr/bin

# tcl-tls from source
# needs tcl-tls >= 1.7.12
# see https://github.com/flightaware/piaware/issues/35
RUN \
  mkdir /build && \
  apk add \
    --no-cache \
    make && \
  apk add \
    --no-cache \
    --repository 'http://dl-cdn.alpinelinux.org/alpine/edge/main' \
    tcl \
    tcl-tls && \
  wget https://github.com/tcltk/tcllib/archive/tcllib-1-19.tar.gz -O - \
    | tar -xzC /build/ && \
  (cd /build/tcllib-tcllib-1-19 && ./configure && make install) && \
  wget https://github.com/flightaware/piaware/archive/v3.6.3.tar.gz -O - \
    | tar -xzC /build && \
  apk add \
    --no-cache \
    make \
    ca-certificates \
    gcc \
    musl-dev \
    net-tools \
    tclx && \
  (cd /build/piaware-3.6.3/package && make install) && \
  mkdir -p /usr/lib/piaware && \
  cp -r /build/piaware-3.6.3/programs/piaware/*.tcl /usr/lib/piaware/ && \
  wget https://github.com/flightaware/dump1090/archive/v3.6.3.tar.gz -O - \
    | tar -xzC /build && \
  apk add \
    --no-cache \
    make \
    gcc \
    musl-dev && \
  cd /build/dump1090-3.6.3/ && \
  make BLADERF=no faup1090 && \
  mkdir -p /usr/lib/piaware/helpers && \
  cp faup1090 /usr/lib/piaware/helpers/

RUN \
  apk del \
    --no-cache \
    --rdepends \
    make \
    gcc \
    libc-dev \
    musl-dev \
    ncurses-dev

COPY piaware /usr/bin/
