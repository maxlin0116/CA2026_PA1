# ==============================================================================
# Problem 3-1: GF(2^8) Finite Field Multiplier
# 
# Irreducible Polynomial: m(x) = x^8 + x^4 + x^3 + x + 1 (0x11B)
# Modular reduction constant upon bit 7 overflow: 0x1B
# ==============================================================================

.data
.align 2
# --- Public Test Vectors ---
test_A:   
    .word 0x57, 0x57
test_B:   
    .word 0x83, 0x13
expected: 
    .word 0xC1, 0xFE

num_tests:    .word 2

# Buffer for 2-digit hex string and null terminator
hex_buf:      .space 4
hex_digits:   .asciz "0123456789ABCDEF"

str_title:    .asciz "=== Running Problem 3-1 Tests ===\n"
str_pass:     .asciz "[Pass] Test "
str_colon:    .asciz ": 0x"
str_mul:      .asciz " (x) 0x"
str_eq:       .asciz " = 0x"
str_fail:     .asciz "[FAIL] Mismatch at test index: "
str_expected: .asciz " | Expected: 0x"
str_actual:   .asciz ", Actual: 0x"
str_all_pass: .asciz "=== All Tests Passed! ===\n"
newline:      .asciz "\n"

.text
.globl __start

# ------------------------------------------------------------------------------
# Main Test Suite (DO NOT MODIFY)
# ------------------------------------------------------------------------------
__start:
    li a0, 4
    la a1, str_title
    ecall

    la s0, test_A
    la s1, test_B
    la s2, expected
    la s3, num_tests
    lw s3, 0(s3)           # Total number of test cases
    li s4, 0               # Test index = 0

test_loop:
    beq s4, s3, all_tests_passed

    slli t0, s4, 2
    add t1, s0, t0
    lw a0, 0(t1)           # Operand A
    add t1, s1, t0
    lw a1, 0(t1)           # Operand B

    # Load expected result into callee-saved s5
    add t1, s2, t0
    lw s5, 0(t1)           # s5 = Expected result

    # Call student subroutine
    jal ra, gf28_mul

    # Validate output against expected result
    bne a0, s5, test_failed

    # Print success info
    li a0, 4
    la a1, str_pass
    ecall
    li a0, 1
    mv a1, s4
    ecall
    li a0, 4
    la a1, str_colon
    ecall

    # Print Operand A
    slli t0, s4, 2
    add t1, s0, t0
    lw a0, 0(t1)
    jal ra, print_hex_byte

    li a0, 4
    la a1, str_mul
    ecall

    # Print Operand B
    slli t0, s4, 2
    add t1, s1, t0
    lw a0, 0(t1)
    jal ra, print_hex_byte

    li a0, 4
    la a1, str_eq
    ecall

    # Print Product
    mv a0, s5
    jal ra, print_hex_byte

    li a0, 4
    la a1, newline
    ecall

    addi s4, s4, 1
    j test_loop

all_tests_passed:
    li a0, 4
    la a1, str_all_pass
    ecall
    li a0, 10              # Exit
    ecall

test_failed:
    mv s6, a0              # Save actual result
    li a0, 4
    la a1, str_fail
    ecall
    li a0, 1
    mv a1, s4
    ecall
    li a0, 4
    la a1, str_expected
    ecall
    mv a0, s5              # Print expected
    jal ra, print_hex_byte
    li a0, 4
    la a1, str_actual
    ecall
    mv a0, s6              # Print actual
    jal ra, print_hex_byte
    li a0, 4
    la a1, newline
    ecall
    li a0, 10
    ecall

# ==============================================================================
# Student Implementation: GF(2^8) Finite Field Multiplier
# 
# Interface:
#   - Inputs:  a0 = Polynomial A (0 <= A <= 255)
#              a1 = Polynomial B (0 <= B <= 255)
#   - Outputs: a0 = Product (lower 8 bits, high 24 bits must be zero)
# ==============================================================================
gf28_mul:
    # --------------------------------------------------------------------------
    # ### TODO ###
    # Implement the GF(2^8) multiplication subroutine here.
    # --------------------------------------------------------------------------

    addi sp,sp,-48    # make space for regigster
    sw ra,44(sp)      # save the returm address
    sw a0,40(sp)      # save A
    sw a1,36(sp)      # save B
    sw zero,32(sp)    # save P = 0
    sw zero,28(sp)    # save i = 0
    lw a2,32(sp)      # load i into a2
    
# for(int i = 0; i < 8; i++)
L1:
    addi a2,a2,1      # i++
    
    # calculate B & 1 and check whether it equals to 1(whether to calculate P ^ A)
    lw a1,36(sp)      # load B
    lw a3,32(sp)      # load P in a3
    lw a0,40(sp)      # load A in a0
    andi t0,a1,1      # store B & 1 in t0
    li t1,1
    bne t0,t1,L2      # if B & 1 != 1
    xor a3,a3,a0      # store P ^ A in P

# after the check of b & 1
L2:
    sw a3,32(sp)      # save P
    andi a4,a0,0x80   # store msb_is_one in a4(A is in a0)
    slli a0,a0,1      # A = A << 1
    andi a0, a0, 0xFF # remain uint_8
    li t0,0
    
    # check whether store_is_one == 0
    beq a4,t0,L3      # if store_is_one == 0
    xori  a0,a0,0x1B  # A = A ^ 0x1B
L3:
    srli a1,a1,1      # B = B >> 1
    sw a0,40(sp)      # store current A back to memory
    sw a1,36(sp)      # store current B back to memory
    lw a0,32(sp)      # load P into a0
    
    li t0,8
    blt a2,t0,L1      # if i < 8
    lw ra,44(sp)      # load the return address
    addi sp,sp,48     # restore the register
    jalr zero,0(ra)   # return to the caller

# ------------------------------------------------------------------------------
# Provided Helper: Print Hex Byte (DO NOT MODIFY)
# Follows standard calling convention: saves ra and callee-saved s0.
# ------------------------------------------------------------------------------
print_hex_byte:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)

    mv s0, a0
    la t0, hex_digits
    la t1, hex_buf

    # High nibble
    srli t2, s0, 4
    andi t2, t2, 0xF
    add t3, t0, t2
    lbu t3, 0(t3)
    sb t3, 0(t1)

    # Low nibble
    andi t2, s0, 0xF
    add t3, t0, t2
    lbu t3, 0(t3)
    sb t3, 1(t1)

    sb zero, 2(t1)

    li a0, 4
    la a1, hex_buf
    ecall

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret