# ==============================================================================
# Problem 3-2: Tableless AES-128 S-Box Calculation
# ==============================================================================

.data
.align 2
# --- Public Test Vectors ---
test_in:  
    .word 0x01, 0x53
expected: 
    .word 0x7C, 0xED

num_tests:.word 2

# Buffer for 2-digit hex string
hex_buf:    .space 4
hex_digits: .asciz "0123456789ABCDEF"

str_title:    .asciz "=== Running Problem 3-2 Tests ===\n"
str_pass:     .asciz "[Pass] Test "
str_colon:    .asciz ": S-Box(0x"
str_eq:       .asciz ") = 0x"
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

    la s0, test_in
    la s1, expected
    la s2, num_tests
    lw s2, 0(s2)           
    li s3, 0               

test_loop:
    beq s3, s2, all_tests_passed

    slli t0, s3, 2
    add t1, s0, t0
    lw a0, 0(t1)           # a0 = Input byte (x)

    # Call student subroutine
    jal ra, aes_sbox_calc
    mv s4, a0              # Save output byte

    # Validate output
    slli t0, s3, 2
    add t1, s1, t0
    lw s5, 0(t1)           # s5 = Expected result
    bne s4, s5, test_failed

    # Print success info
    li a0, 4
    la a1, str_pass
    ecall
    li a0, 1
    mv a1, s3
    ecall
    li a0, 4
    la a1, str_colon
    ecall

    # Print Input
    slli t0, s3, 2
    add t1, s0, t0
    lw a0, 0(t1)
    jal ra, print_hex_byte

    li a0, 4
    la a1, str_eq
    ecall

    # Print Output
    mv a0, s4
    jal ra, print_hex_byte

    li a0, 4
    la a1, newline
    ecall

    addi s3, s3, 1
    j test_loop

all_tests_passed:
    li a0, 4
    la a1, str_all_pass
    ecall
    li a0, 10
    ecall

test_failed:
    mv s6, s4              # Save actual result
    li a0, 4
    la a1, str_fail
    ecall
    li a0, 1
    mv a1, s3
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
# Student Implementation: Tableless AES-128 S-Box Calculation
# 
# Interface:
#   - Input:  a0 = Byte x (0 <= x <= 255)
#   - Output: a0 = S-Box output byte
# ==============================================================================
aes_sbox_calc:
    # --------------------------------------------------------------------------
    # ### TODO ###
    # Implement the 2-phase AES S-Box transform dynamically.
    # 
    # Phase 1: Multiplicative Inversion (y = x^254)
    #   - If x == 0, the inverse is 0.
    #
    # Phase 2: Affine Transformation
    #   - Compute y ^ ROL(y,1) ^ ROL(y,2) ^ ROL(y,3) ^ ROL(y,4) ^ 0x63
    # --------------------------------------------------------------------------

    addi sp,sp,-48    # create place for register
    sw ra,44(sp)      # save the return address into 44(sp)
    sw a0,40(sp)      # save x into 40(sp)
    addi a1,a0,0      # y = x + 0 = x
    sw a1,32(sp)      # save y into 32(sp)
    li t0,0
    beq a0,t0,L5      # if x == 0
    sw zero,36(sp)    # save i = 0 into 36(sp)
    lw a1,36(sp)      # load i into a1
L4:
    addi a1,a1,1      # i++
    sw a1,36(sp)      # save i into 36(sp)
    lw a0,32(sp)      # load y from 32(sp) into a0 to be the parameter A
    lw a1,40(sp)      # load x from 40(sp) into a1 to be the parameter B
    jal ra,gf28_mul   # run the function gf28_mul(y,x) and it store the result in a0
    sw a0,32(sp)      # save y = gf28_mul(y,x) into 32(sp)
    li t0,253
    lw a1,36(sp)      # load i 
    blt a1,t0,L4
L5:
    lw a1,32(sp)      # load y from 32(sp) into a1
    lw a2,32(sp)      # s = y
    slli t0,a1,1      # y << 1
    andi t0,t0,0xFF   # uint_8
    srli t1,a1,7      # y >> (8-1) = y >> 7
    or t2,t0,t1       # (y << 1) & 0xFF) | (y >> 7)
    xor a2,a2,t2      # s = s ^ rotl8(y,1)
    slli t0,a1,2      # y << 2
    andi t0,t0,0xFF   # uint_8
    srli t1,a1,6      # y >> (8-2) = y >> 6
    or t2,t0,t1       # (y << 2) & 0xFF) | (y >> 6)
    xor a2,a2,t2      # s = s ^ rotl8(y,2)
    slli t0,a1,3      # y << 3
    andi t0,t0,0xFF   # uint_8
    srli t1,a1,5      # y >> (8-3) = y >> 5
    or t2,t0,t1       # (y << 3) & 0xFF) | (y >> 5)
    xor a2,a2,t2      # s = s ^ rotl8(y,3)
    slli t0,a1,4      # y << 4
    andi t0,t0,0xFF   # uint_8
    srli t1,a1,4      # y >> (8-4) = y >> 4
    or t2,t0,t1       # (y << 4) & 0xFF) | (y >> 4)
    xor a2,a2,t2      # s = s ^ rotl8(y,4)
    xori a2,a2,0x63
    sw a2,32(sp)      # store a2 back to memory
    lw a0,32(sp)      # load the result into a0
    lw ra,44(sp)      # load the return address
    addi sp,sp,48     # restore the space of register
    jalr zero,0(ra)   # return to the caller


# ------------------------------------------------------------------------------
# Helper: GF(2^8) Multiplier
# ------------------------------------------------------------------------------
gf28_mul:
    # --------------------------------------------------------------------------
    # ### TODO ###
    # Copy and paste the result from problem 3-1 (p3_1.s)
    # --------------------------------------------------------------------------

    addi sp,sp,-48
    sw ra,44(sp)      # save the returm address
    sw a0,40(sp)      # save A
    sw a1,36(sp)      # save B
    sw zero,32(sp)    # save P = 0
    sw zero,28(sp)    # save i = 0
    lw a2,32(sp)      # load i into a2
L1:
    addi a2,a2,1      # i++
    lw a1,36(sp)      # load B
    lw a3,32(sp)      # store P in a3
    lw a0,40(sp)      # store A in a0
    andi t0,a1,1      # store B & 1 in t0
    li t1,1
    bne t0,t1,L2      # if B & 1 != 1
    xor a3,a3,a0      # store P ^ A in P
L2:
    sw a3,32(sp)      # save P
    andi a4,a0,0x80   # store msb_is_one in a4
    slli a0,a0,1      # A = A << 1
    andi a0, a0, 0xFF # remain uint_8
    li t0,0
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