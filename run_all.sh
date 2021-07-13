#!/bin/bash

echo "******************************************************"
echo "ASE (O1)"
echo "******************************************************"

FILES=$(pwd)/benchmarks/*.c
for f in $FILES
do
  fullname=$(basename -- "$f")
  filename="${fullname%.*}"
  echo $filename

  ./selfie -c $f -o $filename
  ./ase -l $filename -timeout 18000 -pvi_ubox_bvt 1
  rm $filename

  echo "-------------------------------------------------"
done

echo "ASE (O1) done: $(date)"

echo "******************************************************"
echo "ASE (O2)"
echo "******************************************************"

FILES=$(pwd)/benchmarks/*.c
for f in $FILES
do
  fullname=$(basename -- "$f")
  filename="${fullname%.*}"
  echo $filename

  ./selfie -c $f -o $filename
  ./ase -l $filename -timeout 18000 -pvi_ubox_bvt 2
  rm $filename

  echo "-------------------------------------------------"
done

echo "ASE (O2) done: $(date)"

echo "******************************************************"
echo "PARTI"
echo "******************************************************"

FILES=$(pwd)/benchmarks/*.c
for f in $FILES
do
  fullname=$(basename -- "$f")
  filename="${fullname%.*}"
  echo $filename

  ./selfie -c $f -o $filename
  ./parti -l $filename -timeout 18000 -mit_bvt
  rm $filename

  echo "-------------------------------------------------"
done

echo "PARTI done: $(date)"

echo "******************************************************"
echo "baseline"
echo "******************************************************"

FILES=$(pwd)/benchmarks/*.c
for f in $FILES
do
  fullname=$(basename -- "$f")
  filename="${fullname%.*}"
  echo $filename

  ./selfie -c $f -o $filename
  ./ase -l $filename -timeout 18000 -bvt
  rm $filename

  echo "-------------------------------------------------"
done

echo "baseline done: $(date)"