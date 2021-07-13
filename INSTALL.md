# How to install ASE

## Install on a Linux machine
```
1. sudo apt-get update ;
2. sudo apt-get install -y --no-install-recommends \
       ca-certificates \
       cmake \
       g++ \
       gcc \
       git \
       libc-dev \
       make \
       wget \
       curl ;

3. git clone https://github.com/Boolector/boolector ;
4. cd boolector \
  && git checkout 4999474f4e717c206577fd2b1549bd4a9f4a36e7 \
  && ./contrib/setup-cadical.sh \
  && ./contrib/setup-btor2tools.sh \
  && ./configure.sh --only-cadical  \
  && cd build \
  && make ;

5. cd .. ;
6. make all;
```

### Prerequisite
- ca-certificates
- cmake
- g++
- gcc
- git
- libc-dev
- make
- wget
- curl
- [Boolector](https://boolector.github.io) SMT solver.

## Usage
In the root folder (i.e. ase_artifact) you should find `ase`, `parti`, and `selfie` executables.

The engine can analyze the programs which are written in [C*](https://github.com/cksystemsteaching/selfie) programming language. You can see the available benchmarks in `benchmarks` folder. For more information about C* check https://github.com/cksystemsteaching/selfie.

First, the input program should be compiled to binary using the command below:
```
./selfie -c code.c -o binary
```

Then, you can give the generated binary to the ASE engine as input by using `-l` flag. You can use the following commands to run the approaches in the experimental evaluation of the paper:

- ASE (O1):
```
./ase -l binary -timeout 18000 -pvi_ubox_bvt 1
```
- ASE (O2):
```
./ase -l $filename -timeout 18000 -pvi_ubox_bvt 2
```
- baseline:
```
./ase -l $filename -timeout 18000 -bvt
```