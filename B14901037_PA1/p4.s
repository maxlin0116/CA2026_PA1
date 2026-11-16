# ==============================================================================
# Problem 4: Character Frequency Counter
# 
# Constraints:
#   - Input length: 0 to 200 characters.
#   - Character range: Printable ASCII [32, 126].
# ==============================================================================

.data
.align 0
# --- Public Test Cases ---
pub_test1:    .asciz "AABBAA"
pub_exp1:     .asciz "4A2B"

pub_test2:    .asciz "  hello  "
pub_exp2:     .asciz "4 1e1h2l1o"

.align 2
test_cases: 
    .word pub_test1, pub_test2

expected_cases:
    .word pub_exp1, pub_exp2

num_cases:  .word 2

# Memory allocated for character counting (256 words = 1024 bytes)
freq_array: .space 1024

# Output buffer sized safely for maximum expansion (up to 200 chars * 2 + padding)
output_buf: .space 512

str_title:    .asciz "=== Running Problem 4 Tests ===\n"
str_pass:     .asciz "[Pass] Test "
str_colon:    .asciz ": \""
str_arrow:    .asciz "\" -> \""
str_quote:    .asciz "\"\n"
str_fail:     .asciz "[FAIL] Mismatch at test index: "
str_expected: .asciz " | Expected: \""
str_actual:   .asciz "\", Actual: \""
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

    la s0, test_cases      
    la s1, expected_cases
    la s2, num_cases
    lw s2, 0(s2)           # Total number of test cases
    li s3, 0               # Test index = 0

test_loop:
    beq s3, s2, all_tests_passed

    slli t0, s3, 2
    add t1, s0, t0
    lw s4, 0(t1)           # s4 = Input string pointer

    add t1, s1, t0
    lw s5, 0(t1)           # s5 = Expected output string pointer

    # Call student subroutine
    mv a0, s4              # a0 = Base address of input string
    la a1, output_buf      # a1 = Base address of output buffer
    jal ra, freq_count

    # Compare student output_buf with expected string byte-by-byte
    la t0, output_buf
    mv t1, s5
strcmp_loop:
    lbu t2, 0(t0)
    lbu t3, 0(t1)
    bne t2, t3, test_failed
    beqz t2, test_passed   # Matched up to null terminator
    addi t0, t0, 1
    addi t1, t1, 1
    j strcmp_loop

test_passed:
    li a0, 4
    la a1, str_pass
    ecall
    li a0, 1
    mv a1, s3
    ecall
    li a0, 4
    la a1, str_colon
    ecall
    li a0, 4
    mv a1, s4
    ecall
    li a0, 4
    la a1, str_arrow
    ecall
    li a0, 4
    la a1, output_buf
    ecall
    li a0, 4
    la a1, str_quote
    ecall

    addi s3, s3, 1
    j test_loop

all_tests_passed:
    li a0, 4
    la a1, str_all_pass
    ecall
    li a0, 10              # Exit program
    ecall

test_failed:
    li a0, 4
    la a1, str_fail
    ecall
    li a0, 1
    mv a1, s3
    ecall
    li a0, 4
    la a1, str_expected
    ecall
    li a0, 4
    mv a1, s5
    ecall
    li a0, 4
    la a1, str_actual
    ecall
    li a0, 4
    la a1, output_buf
    ecall
    li a0, 4
    la a1, str_quote
    ecall
    li a0, 10              # Exit program
    ecall


# ==============================================================================
# Student Implementation: Character Frequency Counter
# Interface:
#   - a0: Base address of null-terminated input string
#   - a1: Base address of output buffer
# ==============================================================================
freq_count:
    # --------------------------------------------------------------------------
    # ### TODO ###
    # Implement the frequency counter routine here.
    # 
    # Design Hints:
    # 1. Be mindful that this routine is called multiple times; ensure any 
    #    shared buffer or table is appropriately initialized.
    # 2. Only count printable ASCII characters within the range [32, 126].
    # 3. Format output in ascending ASCII order (e.g., "<count><char>").
    # 4. Remember to null-terminate the output string.
    # 5. A shared frequency buffer 'freq_array' (1024 bytes) is allocated in .data
    #    above for your convenience.
    # --------------------------------------------------------------------------

    addi sp,sp,-560        # create space for register
    sw ra,556(sp)          # save the return address
    sw a0,552(sp)          # save base address of input string
    sw a1,548(sp)          # save base address of output buffer
    li t0,0                # i = 0
    mv t1,sp               # set t1 to be the address of sp
# count[128] = 0
L1:
    addi t0,t0,1           # i++
    sw zero,0(t1)          # set the value whose address is t1 + 0 to 0
    addi t1,t1,4           # t1 point to the next int (sizeof(int) = 4)
    li t2,128          
    blt t0,t2,L1           # if i < 128
L2:
    lw a2,552(sp)          # load base address of input string to a2 => char* ptr = in
L3:
    lbu t3,0(a2)           # load the value whose address is a2 + 0 to t3 => ascii_val = (int)(*ptr)
    beq t3,zero,L4         # if ascii_val == 0
    slli t3,t3,2           # offset = ascii_val * 4 (t3 turn into a address)
    add t3,t3,sp           # sp + offset
    lw t4,0(t3)            # load counts[ascii_val](value whose address is t3 + 0) into t4
    addi t4,t4,1           # counts[ascii_val]++
    sw t4,0(t3)            # store counts[ascii_val] back to memory
    addi a2,a2,1           # ptr++
    beq zero,zero,L3       # back to L3(unconditional)
L4:
    lw a3,548(sp)          # load base address of output buffer to a3 => char* ptr = out
    li t0,31               # i = 32
L5:
    addi t0,t0,1           # i++
    slli t1,t0,2           # calculate the offset
    add t1,t1,sp           # sp + offset
    lw t2,0(t1)            # load counts[i](value whose address is t1 + 0) into t2
    beq t2,zero,L6         # if counts[i] = 0
    li t3,0                # hundred digit = 0
    li t4,0                # hundred digit = 0
# keep subtracting 100 from t2 until it is less than 100
L_sub100:
    li t5,100          
    blt t2,t5,L_sub10      # check whether t2 is less than 100
    addi t2,t2,-100        # t2 = t2 - 100
    addi t3,t3,1           # hundred digit++
    beq zero,zero,L_sub100 # back to L_sub100(unconditional)
# keep subtracting 10 from t2 until it is less tha 10
L_sub10:
    li t5,10
    blt t2,t5,L_writedigit  # check whether t2 is less than 10
    addi t2,t2,-10          # t2 = t2 - 10 
    addi t4,t4,1            # ten digit++
    beq zero,zero,L_sub10   # back to L_sub10(unconditional)
L_writedigit:
    beq t3,zero,L_checktens # whether to write the hundred digit
    addi t5,t3,48           # turn to ascii code
    sb t5,0(a3)             # store the ascii code to the address a3 + 0
    addi a3,a3,1            # a3++
L_checktens:
    bne t4,zero,L_printtens # if the ten is not zero than must print
    beq t3,zero,L_printones # if the hundred is zero and ten is zero than don't print
L_printtens:
    addi t5,t4,48           # turn ten into ascii code
    sb t5,0(a3)             # store the ascii code to the address a3 + 0
    addi a3,a3,1            # a3++
L_printones:
    addi t5,t2,48           # turn one into ascii code
    sb t5,0(a3)             # store the ascii code to the assress a3 + 0
    addi a3,a3,1            # a3++
    sb t0,0(a3)             # store i to the address a3 + 0 => *out_ptr = (char)i
    addi a3,a3,1            # out_ptr++
L6:
    li t1,127
    blt t0,t1,L5            # if i < 127
    sb zero,0(a3)           # store '\0' to tha address a3 + 0 => *out_ptr = '\0'
    lw ra,556(sp)           # load the return address
    addi sp,sp,560          # restore the place of register
    jalr zero,0(ra)         # turn back to the caller