# ==============================================================================
# Problem 2: BST Range Sum
#
# Tree Node Memory Layout (12 bytes per node):
#   - offset 0: val       (4-byte signed integer)
#   - offset 4: left_idx  (4-byte index in node_pool, -1 if NULL)
#   - offset 8: right_idx (4-byte index in node_pool, -1 if NULL)
# ==============================================================================

.data
.align 2

# ------------------------------------------------------------------------------
# Node Pool: All trees are stored consecutively in this shared buffer
# ------------------------------------------------------------------------------
node_pool:
    # --- Tree 0: [10, 5, 15, 3, 7, null, 18] (Public 1, Index 0 ~ 5) ---
    .word 10,  1,  2    # Node 0 (Root of Tree 0)
    .word  5,  3,  4    # Node 1
    .word 15, -1,  5    # Node 2
    .word  3, -1, -1    # Node 3
    .word  7, -1, -1    # Node 4
    .word 18, -1, -1    # Node 5

    # --- Tree 1: [10, 5, 15, 3, 7, 13, 18, 1, null, 6] (Public 2, Index 6 ~ 14) ---
    .word 10,  7,  8    # Node 6 (Root of Tree 1)
    .word  5,  9, 10    # Node 7
    .word 15, 11, 12    # Node 8
    .word  3, 13, -1    # Node 9
    .word  7, 14, -1    # Node 10
    .word 13, -1, -1    # Node 11
    .word 18, -1, -1    # Node 12
    .word  1, -1, -1    # Node 13
    .word  6, -1, -1    # Node 14

# ------------------------------------------------------------------------------
# Test Parameters Table: { root_idx, low, high, expected_sum } (16 bytes each)
# ------------------------------------------------------------------------------
test_params:
    .word 0, 7, 15, 32   # Test 0: Root is Node 0
    .word 6, 6, 10, 23   # Test 1: Root is Node 6

num_tests: .word 2

str_title: .asciz "=== Running Problem 2 Tests ===\n"
str_pass:  .asciz "[Pass] Test "
str_range: .asciz " -> Sum = "
str_fail:     .asciz "[FAIL] Mismatch at test index: "
str_expected: .asciz " | Expected: "
str_actual:   .asciz ", Actual: "
str_all:      .asciz "=== All Tests Passed! ===\n"
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

    la s0, test_params
    la s1, num_tests
    lw s1, 0(s1)           # s1 = total tests
    li s2, 0               # s2 = current test index

test_loop:
    beq s2, s1, all_tests_passed

    la a0, node_pool       # a0 = node_pool base address
    lw a1, 0(s0)           # a1 = root_idx
    lw a2, 4(s0)           # a2 = low
    lw a3, 8(s0)           # a3 = high
    lw s3, 12(s0)          # s3 = expected_sum

    # Call student subroutine
    jal ra, range_sum_bst
    mv s4, a0

    # Validate output
    bne s4, s3, test_failed

    # Print pass log
    li a0, 4
    la a1, str_pass
    ecall
    li a0, 1
    mv a1, s2
    ecall
    li a0, 4
    la a1, str_range
    ecall
    li a0, 1
    mv a1, s4
    ecall
    li a0, 4
    la a1, newline
    ecall

    addi s0, s0, 16        # Move to next test parameters struct
    addi s2, s2, 1
    j test_loop

all_tests_passed:
    li a0, 4
    la a1, str_all
    ecall
    li a0, 10
    ecall

test_failed:
    li a0, 4
    la a1, str_fail
    ecall
    li a0, 1
    mv a1, s2
    ecall
    li a0, 4
    la a1, str_expected
    ecall
    li a0, 1
    mv a1, s3
    ecall
    li a0, 4
    la a1, str_actual
    ecall
    li a0, 1
    mv a1, s4
    ecall
    li a0, 4
    la a1, newline
    ecall
    li a0, 10
    ecall


# ==============================================================================
# Student Implementation: BST Range Sum
# 
# Interface:
#   - a0: Base address of the node pool
#   - a1: Current node index (-1 indicates NULL)
#   - a2: low
#   - a3: high
# Output:
#   - a0: Sum of values in the inclusive range [low, high]
# ==============================================================================
range_sum_bst:
    # --------------------------------------------------------------------------
    # ### TODO ###
    # Implement the recursive BST range sum function here.
    # --------------------------------------------------------------------------

    # save the caller-saved items
    addi sp,sp,-48  # make 48 bytes space for register
    sw ra,44(sp)    # save the return address in sp(44)
    sw a0,40(sp)    # save the base address of the node pool in sp(40)
    sw a1,36(sp)    # save current node index int 36(sp)
    sw a2,32(sp)    # save low in 32(sp)
    sw a3,28(sp)    # save high int 28(sp)
    sw zero,24(sp)  # save sum = 0 in sp(24)
    
    # whether current node is empty
    li t0,-1
    beq a1,t0,L1    # if current node index is -1(i.e. empty node), jump to L1
    
    # load node_pool[index].val in a6
    lw a5,36(sp)    # a5 = index(the offset of node_pool's address)
    li t2,12
    mul a5,a5,t2    # sizeof(node_pool) = 12
    lw a4,40(sp)    # a4 = the address of nood_pool[0]
    add a5,a4,a5    # a5 = the address of node_pool[index]
    lw a6,0(a5)     # a6 = node_pool[index].val(the value store in 0(a5))
    
    ble a6,a3,L2    # if val <= high
    
    # if val is larger than high
    lw a0,40(sp)    # load the base address of the node pool
    lw a1,4(a5)     # load the current node's left index
    lw a2,32(sp)    # load low
    lw a3,28(sp)    # load high
    jal ra,range_sum_bst  # jump to function, and it will save its result in a0
    lw t1,24(sp)    # load the saved sum into t1
    add a0,a0,t1    # add left's range_sum_bst to sum
    lw ra,44(sp)    # restore the return address(used to return to the caller of this callee)
    addi sp,sp,48   # pop items
    jalr zero,0(ra) # return to the caller
    
# if the current node is empty
L1: 
    li a0,0         # set the return value to 0
    addi sp,sp,48   # pop the items
    jalr zero,0(ra) # return to the caller
    
# if val is less than low or is between low and high
L2:
    # check whether val is between low and high
    bge a6,a2,L3
    
    # if val is lower the low
    lw a0,40(sp)    # load the base address of the node pool
    lw a1,8(a5)     # load the current node's right index
    lw a2,32(sp)    # load low
    lw a3,28(sp)    # load high
    jal ra,range_sum_bst  # jump to function, and it will save its result in a0
    lw t1,24(sp)    # load the saved sum into t1
    add a0,a0,t1    # add right's range_sum_bst to sum
    lw ra,44(sp)    # restore the return address(used to return to the caller of this callee) 
    addi sp,sp,48   # pop items
    jalr zero,0(ra) # return to the caller

# if val between low and high 
L3:
    lw t1,24(sp)    # load the saved sum to t1
    add a0,a6,t1    # add current node's value to sum
    sw a0,24(sp)    # save the sum in 24(sp)
    
    # do the left range_sum_bst
    lw a0,40(sp)    # load the base address of the node pool
    lw a1,4(a5)     # load the current node's left index
    lw a2,32(sp)    # load low
    lw a3,28(sp)    # load high
    jal ra,range_sum_bst  # jump to function, and it will save its result in a0
    lw t1,24(sp)    # load the saved sum to t1
    add a0,a0,t1    # add left's range_sum_bst to sum
    sw a0,24(sp)    # save the sum in 24(sp)
    lw ra,44(sp)    # load the return address(used to return to the caller of this callee)
    
    # recalculate the address of node_pool[index]
    lw a5,36(sp)    # a5 = index
    li t2,12
    mul a5,a5,t2    # sizeof(node_pool) = 12
    lw a4,40(sp)    # a4 = the address of nood_pool[0]
    add a5,a4,a5    # a5 = the address of node_pool[index]
    
    # do the right range_sum_bst
    lw a0,40(sp)    # load the base address of the node_pool
    lw a1,8(a5)     # load the current node's right index
    lw a2,32(sp)    # load low
    lw a3,28(sp)    # load high
    jal ra,range_sum_bst  # jump to function, and it will save its result in a0
    lw t1,24(sp)    # load the saves sum to t1
    add a0,a0,t1    # add right's range_sum_bst to sum
    lw ra,44(sp)    # load the return address(used to return to the caller of this callee)
    addi sp,sp,48   # pop items
    jalr zero,0(ra) # retun to the caller
    
    