# Abstract Symbolic Execution (ASE) Engine

ASE is a symbolic execution engine which works on a subset of RISC-V (compiled from [C*](https://github.com/cksystemsteaching/selfie) programming language). The engine uses a decision procedure which is based on *strided value interval* abstraction domain and *bit-vectors*.

Here is a program written in C*:
```
uint64_t main() {
  uint64_t a;
  uint64_t b;
  uint64_t c;

  interval(&a, 0, 100, 1);
  c = a / 2;
  b = a - 10;
  if (b <= 10) {
    c = c + 1;
  } else {
    c = c - 1;
  }

  return 0;
}
```
A symbolic value in this program is determined by `interval(&a, 0, 100, 1)`which assigns integer value interval of `<0, 100, 1>` (values from 0 to 1000 with step 1) to memory address `&a`.

This program is first compiled into a subset of RISC-V using the compiler provided in the `compiler` folder. Then, the generated binary can be analyzed by the ASE engine symbolically and witnesses for each path of the program can be printed.

# How to install the ASE engine

## Install on a Linux machine:
Execute the following commands in a terminal:
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

```
Go to the root directory of the artifact (i.e. ase_artifact folder) and then:
```
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
Now you should see in the *ase_artifact* folder `ase`, `parti`, and `selfie` executables.

## Install on docker (by building docker image locally)
1. download and install docker on your machine
2. run docker
3. **IMPORTANT:** go to docker settings, and then in "Resources" tab: increase the **"Memory"** to at least **'8 GB'** and "CPUs" to 2
4. go to the root directory of the artifact (i.e. ase_artifact folder) where "Dockerfile" is located
5. open a terminal
6. execute the following command: `docker build --tag ase_artifact .`
7. then execute the following command: `docker run -it ase_artifact`

Now you should be able to see the *ase_artifact* folder by executing `ls` command. In the *ase_artifact* folder you should see `ase`, `parti`, and `selfie` executables.

## Install on docker (by pulling from the Docker Hub)
1. download and install docker on your machine
2. run docker
3. **IMPORTANT:** go to docker settings, and then in "Resources" tab: increase the **"Memory"** to at least **'8 GB'** and "CPUs" to 2
4. open a terminal
5. execute `docker pull aabyaneh/ase_artifact`
6. execute the following command: `docker run -it aabyaneh/ase_artifact`

Now you should be able to see the *ase_artifact* folder by executing `ls` command. In the *ase_artifact* folder you should see `ase`, `parti`, and `selfie` executables.

# How to execute
To run the ASE engine on a set of benchmarks do the following.

## Reproduction of the results:
After successfully installing the ASE tool, you see `ase`, `parti`, and `selfie` executables inside the *ase_artifact* folder.

To reproduce the results of the paper, run the following script:
```
run_all.sh
```
which runs the tool on the benchmarks mentioned in the paper. When the execution of the script is finished, you can find the generated `output.csv` file inside *ase_artifact* folder. The data for Figure 5 of the paper can be found in the `output.csv` file.

**IMPORTANT**. Since we are reporting the execution time in Figure 5 of the paper, depending on the machine which the experiments are executed the results may vary. So, do not expect the same execution time as Figure 5 when executing the benchmarks.

**IMPORTANT**. Since we are reporting the execution time, it is very important that the machine which the experiment are running on has enough resources (no racing, no virtual machine). Otherwise, the generated result will not be reliable.

**IMPORTANT**. The execution of the experiment might take a long time. Therefore, we provided another script called
```
run_random.sh
```
which executes the reported approaches in Figure 5 of the paper for a randomly chosen benchmark. The result will be copied to `output.csv`.

## General Usage:
In the root folder (i.e. ase_artifact) you should see `ase`, `parti`, and `selfie` executables.

The engine can analyze the programs which are written in [C*](https://github.com/cksystemsteaching/selfie) programming language. You can see the available benchmarks in `benchmarks` folder. For more information about C* check https://github.com/cksystemsteaching/selfie.

A symbolic value can be defined as `interval(memory address, lower bound, upper bound, step)`, for example:
```
uint64_t a;
interval(&a, 0, 1000, 1);
```
where `interval(&a, 0, 1000, 1)`assigns integer value interval of `<0, 1000, 1>` (values from 0 to 1000 with step 1) to memory address `&a`.
```
uint64_t b;
b = malloc(10 * 8);
interval(b, 0, 1000, 1);
```
where `interval(b, 0, 1000, 1)`assigns integer value interval of `<0, 1000, 1>` (values from 0 to 1000 with step 1) to memory address `b`.


Once you have written a program in C*, first the input program should be compiled to binary using the command below:
```
./selfie -c code.c -o binary
```

Then, the generated binary should be passed to the ASE engine as input by using the `-l` flag. You can use the following commands to run the ASE approaches mentioned in the experimental evaluation of the paper:

- ASE (O1):
```
./ase -l binary -timeout 18000 -pvi_ubox_bvt 1
```
- ASE (O2):
```
./ase -l binary -timeout 18000 -pvi_ubox_bvt 2
```
- baseline:
```
./ase -l binary -timeout 18000 -bvt
```

For example: consider the following program written in C*:
```
uint64_t main() {
  uint64_t a;
  uint64_t b;
  uint64_t c;

  interval(&a, 0, 100, 1);
  c = a / 2;
  b = a - 10;
  if (b <= 10) {
    c = c + 1;
  } else {
    c = c - 1;
  }

  return 0;
}
```

You can run the following command to execute the program symbolically:
- ASE (O1):
```
./ase -l binary -pvi_ubox_bvt 1
```
- ASE (O2):
```
./ase -l binary -pvi_ubox_bvt 2
```
- baseline:
```
./ase -l binary -bvt
```