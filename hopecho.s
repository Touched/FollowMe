.align 2
.thumb
.thumb_func

main:
mov r2, r0
ldr r0, store
ldrb r1, [r0]
cmp r1, #0x14
bge maybe_hopping
strb r2, [r0]
mov r2, r1
sub r1, #0x14
cmp r1, #0x3
ble lockplayer
storeit:
ldr r1, store
add r1, #0x1
strb r2, [r1]
resume:
mov r1, r7
mov r0, r4
ldr r3, return
bx r3

maybe_hopping:
cmp r1, #0x17
ble hopping

hopping:
cmp r2, r1
beq nohop
b storeit

nohop:
sub r2, #0x14
b resume

lockplayer:
b storeit

.align 2
store: .word 0x02036E35
return: .word 0x08062DEE+1
