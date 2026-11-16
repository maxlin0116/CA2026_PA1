	.file	"P2.c"
	.text
	.globl	range_sum_bst
	.type	range_sum_bst, @function
range_sum_bst:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movl	%ecx, -36(%rbp)
	cmpl	$-1, -28(%rbp)
	jne	.L2
	movl	$0, %eax
	jmp	.L7
.L2:
	movl	$0, -16(%rbp)
	movl	-28(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$2, %rax
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movq	(%rax), %rdx
	movq	%rdx, -12(%rbp)
	movl	8(%rax), %eax
	movl	%eax, -4(%rbp)
	movl	-12(%rbp), %eax
	cmpl	%eax, -36(%rbp)
	jge	.L4
	movl	-8(%rbp), %esi
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	range_sum_bst
	addl	%eax, -16(%rbp)
	jmp	.L5
.L4:
	movl	-12(%rbp), %eax
	cmpl	%eax, -32(%rbp)
	jle	.L6
	movl	-4(%rbp), %esi
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	range_sum_bst
	addl	%eax, -16(%rbp)
	jmp	.L5
.L6:
	movl	-12(%rbp), %eax
	addl	%eax, -16(%rbp)
	movl	-8(%rbp), %esi
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	range_sum_bst
	addl	%eax, -16(%rbp)
	movl	-4(%rbp), %esi
	movl	-36(%rbp), %ecx
	movl	-32(%rbp), %edx
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	range_sum_bst
	addl	%eax, -16(%rbp)
.L5:
	movl	-16(%rbp), %eax
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	range_sum_bst, .-range_sum_bst
	.section	.rodata
	.align 8
.LC0:
	.string	"Test 1 Output: %d (Expected: 32)\n"
	.align 8
.LC1:
	.string	"Test 2 Output: %d (Expected: 23)\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$240, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$10, -224(%rbp)
	movl	$1, -220(%rbp)
	movl	$2, -216(%rbp)
	movl	$5, -212(%rbp)
	movl	$3, -208(%rbp)
	movl	$4, -204(%rbp)
	movl	$15, -200(%rbp)
	movl	$-1, -196(%rbp)
	movl	$6, -192(%rbp)
	movl	$3, -188(%rbp)
	movl	$-1, -184(%rbp)
	movl	$-1, -180(%rbp)
	movl	$7, -176(%rbp)
	movl	$-1, -172(%rbp)
	movl	$-1, -168(%rbp)
	movl	$0, -164(%rbp)
	movl	$-1, -160(%rbp)
	movl	$-1, -156(%rbp)
	movl	$18, -152(%rbp)
	movl	$-1, -148(%rbp)
	movl	$-1, -144(%rbp)
	leaq	-224(%rbp), %rax
	movl	$15, %ecx
	movl	$7, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	range_sum_bst
	movl	%eax, -232(%rbp)
	movl	-232(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$10, -128(%rbp)
	movl	$1, -124(%rbp)
	movl	$2, -120(%rbp)
	movl	$5, -116(%rbp)
	movl	$3, -112(%rbp)
	movl	$4, -108(%rbp)
	movl	$15, -104(%rbp)
	movl	$5, -100(%rbp)
	movl	$6, -96(%rbp)
	movl	$3, -92(%rbp)
	movl	$7, -88(%rbp)
	movl	$-1, -84(%rbp)
	movl	$7, -80(%rbp)
	movl	$9, -76(%rbp)
	movl	$-1, -72(%rbp)
	movl	$13, -68(%rbp)
	movl	$-1, -64(%rbp)
	movl	$-1, -60(%rbp)
	movl	$18, -56(%rbp)
	movl	$-1, -52(%rbp)
	movl	$-1, -48(%rbp)
	movl	$1, -44(%rbp)
	movl	$-1, -40(%rbp)
	movl	$-1, -36(%rbp)
	movl	$0, -32(%rbp)
	movl	$-1, -28(%rbp)
	movl	$-1, -24(%rbp)
	movl	$6, -20(%rbp)
	movl	$-1, -16(%rbp)
	movl	$-1, -12(%rbp)
	leaq	-128(%rbp), %rax
	movl	$10, %ecx
	movl	$6, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	range_sum_bst
	movl	%eax, -228(%rbp)
	movl	-228(%rbp), %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
