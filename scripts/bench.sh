#!/bin/bash

cd "$(dirname "$0")"

echo "=== C ==="
gcc -O3 -o nbody_c nbody.c -lm
./nbody_c
rm -f nbody_c
echo

echo "=== Julia ==="
julia nbody.jl
echo

echo "=== Python ==="
python3 nbody.py
