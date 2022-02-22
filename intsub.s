    // intsub function in this file

    .arch armv8-a
    .global intsub

// @param x0: the first integer
// @param x1: the second integer
// @return x3: x0 - x1
intsub:
   stp    x19, x20, [sp, -16]!
   stp    x21, x22, [sp, -16]!
   stp    x23, x24, [sp, -16]!
   stp    x25, x26, [sp, -16]!
   stp    x27, x28, [sp, -16]!
   stp    x29, x30, [sp, -16]! //Store FP, LR.
   mov x19, x0		// First integer
   mov x20, x1		// Second integer
   mov x21, #0		// Temp
loop:
	cmp x20, #0		
	b.eq return
	mvn x21, x19 // tmp = NOT a
	and x21, x20, x21 // tmp = tmp AND b
	eor x19, x19, x20 // x = x XOR b
	lsl x20, x21, #1 // b = tmp << 1
	b loop

return:
   mov x3, x19
   ldp    x29, x30, [sp], #16
   ldp    x27, x28, [sp], #16
   ldp    x25, x26, [sp], #16
   ldp    x23, x24, [sp], #16
   ldp    x21, x22, [sp], #16
   ldp    x19, x20, [sp], #16
   ret
