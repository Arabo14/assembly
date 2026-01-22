This project implements a pseudo-random password generator using a 32-bit Linear Feedback Shift Register (LFSR), 
combining C and IA-32 assembly (AT&T syntax). The goal is to generate secure-looking passwords based on user 
input: desired password length and character set (alphabetic, numeric, symbolic, alphanumeric, or mixed). 
The C portion handles user interaction, input validation, seed generation, and output, while the core random
charactergeneration logic is implemented in assembly. The LFSR, written entirely in assembly, uses specific tap
positions (bits 32, 30, 26, and 25) to produce a sequence of pseudo-random bits, which are then mapped to printable ASCII
characters based on the selected character set. The project demonstrates modular design, low-level bit manipulation, 
and cross-language integration between C and assembly.

  function lfsr_next_char(charset_type):
    state ← current LFSR state

    // Compute feedback bit using taps (32, 30, 26, 25)
    feedback ← XOR(
        bit(state, 31),
        bit(state, 29),
        bit(state, 25),
        bit(state, 24)
    )

    // Update LFSR
    state ← (state << 1) OR feedback
    state ← state masked to 32 bits
    save state

    // Select character set based on charset_type
    charset ← selected character array
    length ← size of selected charset

    // Use LFSR output to pick a character
    index ← state mod length
    return charset[index]
