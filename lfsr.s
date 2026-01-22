.section .data
lfsr_state:
    .long 0xACE1ACE1        # Initial LFSR seed (will be overwritten by lfsr_seed)

# Character sets for each mode
charsets:
    .string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"                  # 0: Alpha
    .string "0123456789"                                                           # 1: Numeric
    .string "!@#$%^&*()-_=+[]{}"                                                   # 2: Symbols
    .string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"        # 3: Alphanumeric
    .string "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-_=+[]{}"  # 4: Mixed

# Byte offsets into `charsets` for each mode
charset_offsets:
    .int 0, 52, 62, 80, 142

.section .text
.globl lfsr_next_char
.type lfsr_next_char, @function

# char lfsr_next_char(int charset_type)
# Generates the next character using LFSR output
lfsr_next_char:
    pushl %ebp
    movl %esp, %ebp

    # Save callee-saved registers
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    movl 8(%ebp), %eax        # Load `charset_type` argument into %eax

    # Load current LFSR state
    movl lfsr_state, %ecx

    # LFSR Operation (based on taps at 32, 30, 26, 25) 
    xorl %edx, %edx           # Clear %edx (for XOR accumulation)

    movl %ecx, %ebx
    shrl $0, %ebx           # bit 31
    xorl %ebx, %edx

    movl %ecx, %ebx
    shrl $2, %ebx           # bit 29
    xorl %ebx, %edx

    movl %ecx, %ebx
    shrl $6, %ebx           # bit 25
    xorl %ebx, %edx

    movl %ecx, %ebx
    shrl $7, %ebx           # bit 24
    xorl %ebx, %edx

    andl $1, %edx             # Isolate new bit (feedback)
    shll $1, %ecx             # Shift LFSR left by 1
    orl %edx, %ecx            # Insert new bit into LSB
    andl $0xFFFFFFFF, %ecx    # Mask to 32 bits (sanity)

    # Store updated LFSR state
    movl %ecx, lfsr_state

    # Select appropriate character set 

    movl %eax, %ebx           # %ebx = charset_type (0–4)

    # Load offset for selected charset
    leal charset_offsets, %esi
    movl (%esi, %ebx, 4), %edx      # %edx = offset
    leal charsets, %esi
    addl %edx, %esi                 # %esi now points to base of selected charset

    # Get charset length based on type 
    cmpl $0, %eax
    je len_alpha
    cmpl $1, %eax
    je len_numeric
    cmpl $2, %eax
    je len_symbols
    cmpl $3, %eax
    je len_alphanum
    cmpl $4, %eax
    je len_mixed

len_alpha:
    movl $52, %ebx
    jmp select
len_numeric:
    movl $10, %ebx
    jmp select
len_symbols:
    movl $18, %ebx
    jmp select
len_alphanum:
    movl $62, %ebx
    jmp select
len_mixed:
    movl $80, %ebx

# Select a character from charset using LFSR output 
select:
    xorl %edx, %edx
    movl %ecx, %eax           # %eax = LFSR value
    divl %ebx                 # divide by charset length → remainder in %edx

    # Load character from charset[remainder]
    movzbl (%esi, %edx, 1), %eax

    # Restore state and return character 
    popl %edi
    popl %esi
    popl %edx
    popl %ecx
    popl %ebx
    popl %ebp
    ret

# void lfsr_seed(unsigned int seed)
# Sets the initial seed for the LFSR
.globl lfsr_seed
.type lfsr_seed, @function
lfsr_seed:
    movl 4(%esp), %eax        # Load `seed` argument
    movl %eax, lfsr_state     # Store to global LFSR state
    ret

