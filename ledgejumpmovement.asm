.text
.align 2
.thumb
.thumb_func
.global jump_2_with_sound_new

main:
	push {r4, lr}
	mov r4, r0
	mov r0, #0xA
	bl +0x16090
	mov r0, r4
	bl +0x7ED4
	ldr r1, buttonz
	ldrb r1, [r1]
	mov r4, #0x2
	and r1, r4
	beq next
	ldr r1, walkrun
	ldrb r1, [r1]
	cmp r1, #0x2
	beq next
	add r0, #0x70
next:
	mov r1, #0x8
	bl -0x218
	pop {r4, pc}

.align 2
buttonz:	.word 0x0300311C
walkrun:	.word 0x02037078

/*insert at 0805C23C*/
