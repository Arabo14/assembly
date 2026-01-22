# LFSR Password Generator (C + IA-32 Assembly)

This project is a command-line password generator that uses a **32-bit Linear Feedback Shift Register (LFSR)** written in **IA-32 (x86) assembly** to produce pseudo-random output. A C driver program seeds the LFSR and generates passwords using selectable character sets such as letters, numbers, symbols, or a mixed set.

## Features
- Assembly-based 32-bit LFSR random generator
- C program interface for user input (length + character set)
- Multiple character set modes:
  - Alphabet only
  - Numbers only
  - Symbols only
  - Alphanumeric
  - Mixed (letters + numbers + symbols)
- Seeded using a mix of `time()`, `getpid()`, and `clock()` for variation

## Project Structure
- `main.c` – Reads user input, seeds the LFSR, prints generated password
- `lfsr.s` – Assembly implementation of:
  - `lfsr_seed(seed)` to set the LFSR state
  - `lfsr_next_char(type)` to return the next character from the selected charset
- `Makefile` – Builds the program using 32-bit compilation

## How It Works
1. The program asks for a password length and a character set mode.
2. The C code creates a seed using system timing and process data, then calls `lfsr_seed(seed)`.
3. For each character, C calls `lfsr_next_char(mode)`.
4. The assembly function updates the LFSR state using XOR feedback taps and maps the result into the selected charset using modulo arithmetic.

## Build and Run

### Compile
```bash
make
