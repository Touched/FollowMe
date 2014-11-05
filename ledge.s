.include "config.s"

.align 2
.thumb
.thumb_func

main:
    ldr r3, =FOLLOW_MESSAGE
    ldrb r1, [r3]
    
    cmp r1, #MESSAGE_NONE
    beq set_message
    
    cmp r1, #MESSAGE_HOP
    beq message_hop
    
    mov r2, r0
    b resume

set_message:
    mov r1, #MESSAGE_HOP
    strb r1, [r3]
    ldr r2, =LAST_MOVED_DIRECTION @ Should change this to "hopped direction". This causes glitches if hopping side-on 
    ldrb r2, [r2]
    mov r1, #0x10
    add r2, r1
    b resume
    
message_hop:
    ldr r2, =LAST_MOVED_DIRECTION
    ldrb r2, [r2]
    mov r1, #0x10
    add r2, r1
    mov r1, #MESSAGE_NONE
    strb r1, [r3]
    
resume: 
    mov r0, r4
    mov r1, r7
    
    ldr r3, exit
    bx r3
    
.align 2
exit: .word 0x08062E3C + 1
