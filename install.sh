#!/bin/sh

sudo apt-get update ;
sudo apt-get install -y --no-install-recommends \
       ca-certificates \
       cmake \
       g++ \
       gcc \
       git \
       libc-dev \
       make \
       wget \
       curl ;

git clone https://github.com/Boolector/boolector ;
cd boolector \
  && git checkout 4999474f4e717c206577fd2b1549bd4a9f4a36e7 \
  && ./contrib/setup-cadical.sh \
  && ./contrib/setup-btor2tools.sh \
  && ./configure.sh --only-cadical  \
  && cd build \
  && make ;

cd .. ; cd .. ;
make all;