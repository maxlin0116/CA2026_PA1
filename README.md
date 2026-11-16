# CA2026 Programming Assignment 1

This repository contains solutions and supporting files for Computer Architecture
2026 Programming Assignment 1. The assignment covers compiler optimization,
RISC-V assembly, recursive data structures, finite-field arithmetic, AES
S-box computation, and character-frequency counting.

## Repository layout

- `CA2026_PA1/` - primary assignment source files:
  - `p1.c` - compiler optimization analysis example
  - `p2.s` - BST range-sum routine and tests
  - `p3_1.s` - GF(2^8) multiplication routine and tests
  - `p3_2.s` - tableless AES-128 S-box routine and tests
  - `p4.s` - character-frequency counter and tests
- `CA2026_PA1_v2/` - alternate copy of the assignment sources
- `P2.c`, `P3-1.c`, `P3-2.c`, `P4.c` - C reference implementations
- `B14901037_report.tex` and `B14901037_report.pdf` - assignment report
- `image/bin/jupiter` - bundled RISC-V assembler and simulator

## Requirements

- GCC or another C compiler for the reference programs
- Linux, macOS, or WSL
- No separate RISC-V simulator installation is required; Jupiter is included

## Running the RISC-V programs

From the repository root:

```bash
./image/bin/jupiter CA2026_PA1/p2.s
./image/bin/jupiter CA2026_PA1/p3_1.s
./image/bin/jupiter CA2026_PA1/p3_2.s
./image/bin/jupiter CA2026_PA1/p4.s
```

Each assembly file contains its own test data and prints pass/fail results.

## Building and running the C references

```bash
gcc -std=c11 -Wall -Wextra P2.c -o p2_reference
gcc -std=c11 -Wall -Wextra P3-1.c -o p3_1_reference
gcc -std=c11 -Wall -Wextra P3-2.c -o p3_2_reference
gcc -std=c11 -Wall -Wextra P4.c -o p4_reference

./p2_reference
./p3_1_reference
./p3_2_reference
./p4_reference
```

To compile the Problem 1 C source as an object file:

```bash
gcc -std=c11 -Wall -Wextra -c CA2026_PA1/p1.c -o p1.o
```
