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

// @param x5: The address of the first operator
// @param w4: The value of the second operator
// @return void
.global compare_operators
compare_operators:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldrb w5, [x5]
	cmp w4, w5
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


// @params none
// @return x1: The character that was read
.global read_character
read_character:
    stp    x29, x30, [sp, -16]!
    add    x29, sp, 0
	ldr x0, =read_character_string
	ldr x1, =op_input	// x1 <- &op_input
	bl scanf			// x1 <- undefined
	ldr x1, =op_input 	// x1 <- &op_input
	ldr x1, [x1]		// x1 <- *x1
    ldp    x29, x30, [sp], 16
	ret

.global main
main:
	mov x1, #1
	bl print_prompt		// print the prompt for input #1
	bl read_integer		// get an integer from the user
	add w21, w1, #0 	// store the first integer in w21

	mov x1, #2
	bl print_prompt		// print the prompt for input #2
	bl read_integer		// get an integer from the user
	add w22, w1, #0		// store the second integer in w22


	ldr x0, =operation_prompt
	bl printf
	bl read_character
	mov x23, x1			// Store the operator in x23

	mov x0, x21			// x0 <- first integer
	mov x1, x22			// x1 <- second integer
	mov x4, x23			// x4 <- operator

check_add:
	ldr x5, =op_add			// compare the entered operator with '+'
	bl compare_operators
	b.ne check_sub			// if the operator isn't a '+', continue
	bl intadd				// otherwise, call intadd
	b print_result			// print the result
check_sub:
	ldr x5, =op_sub			// compare the entered operator with '-'
	bl compare_operators
	b.ne check_mul			// if the operator isn't a '-', continue
	bl intsub				// otherwise, call intsub
	b print_result			// print the result
check_mul:
	ldr x5, =op_mul			// compare the entered operator with '*'
	bl compare_operators	
	b.ne invalid_operator	// if the operator isn't a '*', it must be invalid
	bl intmul				// otherwise, call intmul
	b print_result			// print the result
invalid_operator:
	ldr x0, =invalid_operator_string	// print error message
	bl printf
print_result:
	ldr x0, =result_string	// print the result of an operation
	mov x1, x3				// result always stored in x3
	bl printf
prompt_again:
	ldr x0, =prompt_again_str			// print out message
	bl printf
	bl read_character		// get a character from the user
	mov x4, x1
	ldr x5, =yes
	bl compare_operators				
	b.ne end				// if the character is not 'y', quit
	b main					// otherwise, restart main
end:
	bl exit					// quit the program
read_integer_string:
	.asciz "%d"
prompt_again_str:
	.asciz "Again? "
read_character_string:
	.asciz " %c"
prompt_string:
	.asciz "Enter Number %d: "
invalid_operator_string:
	.asciz "Invalid Operation Entered.\n"
result_string:
	.asciz "Result is: %d\n"
operation_prompt:
	.asciz "Enter Operation: "
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
