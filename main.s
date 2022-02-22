    // Template main.s file for Lab 3
    // Peter Edmonds, Samuel Lee, Cameron Hardy

    .arch armv8-a
	.text

// @params x1: The number to print following the prompt
// @return: void
.global print_prompt
print_prompt:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldr x0, =prompt_string
	bl printf
    ldp    x29, x30, [sp], 16
	ret

// @param x0: The address of the first operator
// @param w1: The value of the second operator
// @return void
.global compare_operators
compare_operators:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldrb w0, [x0]
	cmp w1, w0
    ldp    x29, x30, [sp], 16
	ret

// @params none
// @return x1: The integer that was read
.global read_integer
read_integer:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldr x0, =read_integer_string
	add x1, x29, 16
	bl scanf
	ldr x1, [x29, 16]
    ldp    x29, x30, [sp], 16
	ret


.global get_int
// @params none
// @return x1: The operation that was read
.global read_character
read_character:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldr x0, =read_character_string
	ldr x1, =op_input
	bl scanf
	ldr x1, =op_input
	ldr x1, [x1]
    ldp    x29, x30, [sp], 16
	ret

.global main
main:
	mov x21, #0	// Number 1
	mov x22, #0	// Number 2
	mov x23, #0	// Operation

	mov x1, #1
	bl print_prompt
	bl read_integer	
	add w21, w1, #0 	// Store the first integer in x21

	mov x1, #2
	bl print_prompt
	bl read_integer
	add w22, w1, #0


	ldr x0, =operation_prompt
	bl printf

	bl read_character
	mov x23, x1		// Store the operator in x23

check_add:
	ldr x0, =op_add
	bl compare_operators
	b.ne check_sub
	mov x0, x21
	mov x1, x22
	bl intadd
	ldr x0, =result_string
	mov x1, x3
	bl printf
	b prompt_again
check_sub:
	ldr x0, =op_sub
	bl compare_operators
	b.ne check_mul
	mov x0, x21
	mov x1, x22
	bl intsub
	ldr x0, =result_string
	mov x1, x3
	bl printf
	b prompt_again
check_mul:
	ldr x0, =op_mul
	bl compare_operators
	b.ne invalid_operator
	mov x0, x21
	mov x1, x22
	bl intmul
	ldr x0, =result_string
	mov x1, x3
	bl printf
	b prompt_again
invalid_operator:
	// If we got here, we didn't match a valid operator
	ldr x0, =invalid_operator_string
	bl printf
prompt_again:
	ldr x0, =prompt_again_str
	bl printf
	bl read_character
	ldr x0, =yes
	bl compare_operators
	b.ne end
	b main
end:
	bl exit
prompt_again_str:
	.asciz "Again? "
prompt_string:
	.asciz "Enter Number %d: "
invalid_operator_string:
	.asciz "Invalid Operation Entered.\n"
result_string:
	.asciz "Result is: %d\n"
operation_prompt:
	.asciz "Enter Operation: "
read_character_string:
	.asciz " %c"
read_integer_string:
	.asciz "%d"
.balign 8
yes:
	.byte 'y'
.balign 8
op_add:
	.byte '+'
.balign 8
op_sub:
	.byte '-'
.balign 8
op_mul:
	.byte '*'
.data
op_input:
	.word 0


