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
    python3 \
    python3-dev \
    ca-certificates \
    gcc \
    musl-dev \
    net-tools \
    tclx && \
  (cd /build/piaware-3.6.3/package && make install) && \
  mkdir -p /usr/lib/piaware && \
  cp -r /build/piaware-3.6.3/programs/piaware/*.tcl /usr/lib/piaware/ && \
  mkdir -p /usr/lib/piaware/helpers/ && \
  wget https://github.com/mutability/mlat-client/archive/v0.2.10.tar.gz -O - \
    | tar -xzC /build/ && \
  (cd /build/mlat-client-0.2.10 && pip3 install .) && \
  ln -s /usr/bin/fa-mlat-client /usr/lib/piaware/helpers/ && \
  apk del \
    --no-cache \
    --rdepends \
    make \
    gcc \
    musl-dev \
    python3-dev && \
  rm -rf \
    /build \
    /usr/bin/qemu-arm-static

COPY \
  --from=danmilon/dump1090-fa-arm32v6:latest \
  /usr/bin/faup1090 \
  /usr/lib/piaware/helpers/

COPY piaware /usr/bin/
CMD ["piaware", "-plainlog"]
