#!/bin/sh

apt-get update ;
apt-get install -y --no-install-recommends \
       ca-certificates \
       cmake \
       g++ \
       gcc \
       git \
       libc-dev \
       make \
       wget \
       curl ;

g++ --version ;
gcc --version ;

git clone https://github.com/Boolector/boolector ;
cd boolector \
  && git checkout 4999474f4e717c206577fd2b1549bd4a9f4a36e7 \
  && ./contrib/setup-cadical.sh \
  && ./contrib/setup-btor2tools.sh \
  && ./configure.sh --only-cadical  \
  && cd build \
  && make ;

cd .. ;
make all;