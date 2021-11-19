# Abstract Symbolic Execution (ASE) Engine

This is the artifact for the paper *ASE: A Value Set Decision Procedure for Symbolic Execution* by Alireza S. Abyaneh and Christoph M. Kirsch published at ASE 2021.

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
A symbolic value in this program is determined by `interval(&a, 0, 100, 1)` which assigns integer value interval of `<0, 100, 1>` (values from 0 to 100 with step 1) to memory address `&a`.

This program is first compiled into a subset of RISC-V using the compiler provided in the `compiler` folder. Then, the generated binary can be analyzed by the ASE engine symbolically and witnesses for each path of the program can be printed at each endpoint of the program.

## How to install the ASE engine:
Please check `INSTALL.md` file.

## How to run the experiments:
In this section we explain how to run the ASE engine on a set of benchmarks.

### Platform we used
- A 512GB NUMA machine with four 16-core 2.3 GHz AMD Opteron 6376 processors (16KB L1 data cache, 64KB L1 instruction cache, 16MB L2 cache, 16MB L3 cache) and Linux kernel version 4.15.
- [Boolector](https://boolector.github.io/) version 3.2.1 with CaDiCaL SAT solver.
- GCC and G++ version 9.3.

**IMPORTANT**. Since we are reporting execution times, it is important that the machine on which the experiments are running has enough resources (at least 8 GB of RAM, and 2 CPU cores). Otherwise, the generated execution times will not be accurate.

**IMPORTANT**. Moreover, running the experiments on a virtual machine (docker, virtualbox, etc.) will not produce accurate execution times. For reproducing (relative) execution time measurements, you need to install the code natively on a real Linux machine.

### Reproduction of the results
After successfully installing the ASE engine, you see `ase`, `parti`, and `selfie` executables inside the *ase_artifact* folder.

To reproduce the results of the paper, run the following script:
```
run_all.sh
```
which runs the engine on the benchmarks mentioned in the paper. When the execution of the script is finished, you can find the generated `output.csv` file inside *ase_artifact* folder. The data in the `output.csv` file corresponds to the data reported in the ASE paper.

**IMPORTANT**. Since we are reporting the execution times in the ASE paper, depending on the machine which the experiments are executed on the results may vary. So, do not expect the same execution times as in the ASE paper when executing the benchmarks.

**IMPORTANT**. The execution of the experiment might take a long time. Therefore, we provide another script called
```
run_random.sh
```
which executes the reported approaches in the ASE paper for a randomly chosen benchmark. The result will be copied to `output.csv`.

## General Usage:
The engine can analyze programs written in the [C*](https://github.com/cksystemsteaching/selfie) programming language. You can see the available benchmarks in `benchmarks` folder. For more information about C* refer to https://github.com/cksystemsteaching/selfie.

A symbolic value can be defined as `interval(memory_address, lower_bound, upper_bound, step)`, for example:
```
uint64_t a;
interval(&a, 0, 1000, 1);
```
where `interval(&a, 0, 1000, 1)` assigns integer value interval of `<0, 1000, 1>` (values from 0 to 1000 with step 1) to memory address `&a`.
```
uint64_t b;
b = malloc(10 * 8);
interval(b, 0, 1000, 1);
```
where `interval(b, 0, 1000, 1)` assigns integer value interval of `<0, 1000, 1>` (values from 0 to 1000 with step 1) to memory address `b`.

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

#### Configuration parameters:
To run the engine on very large input programs you may need to increase the configuration parameters in `ase.hpp` and `se.hpp` files of the source code and then rebuild the source code:

- max_trace_length: the maximum length of the trace used by the engine.
- max_ast_nodes_trace_length: the maximum length of the AST (Abstract Syntax Tree) nodes trace.
- initial_ast_nodes_trace_length: the initial length of the AST nodes trace.
- max_number_of_intervals: the maximum number of value intervals used to represent the set of values for a variable.
- max_number_of_involved_inputs: the maximum number of involved input values in a variable.
- memory_allocation_step_ast_nodes_trace: the memory allocation step for AST nodes trace.

To reproduce the results of the paper you do not need to change these configuration parameters.