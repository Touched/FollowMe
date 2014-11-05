.include "config.s"

.align 2
.thumb
.thumb_func

main:
    ldr r3, =FOLLOW_MESSAGE
    ldrb r1, [r3]
    
    cmp r1, #MESSAGE_NONE
    beq set_message
    
    @cmp r1, #MESSAGE_HOP
    @beq message_hop
    
    mov r2, r0
    b resume

set_message:
    mov r1, #MESSAGE_HOP
    strb r1, [r3]
    
    
    @ldr r2, =LAST_MOVED_DIRECTION @ Should change this to "hopped direction". This causes glitches if hopping side-on 
    @ldrb r2, [r2]
    
    
    
    @mov r1, #0x10
    @add r2, r1
    @b resume
    
message_hop:
    @ Stores the direction the player is hopping in as the new last direction
    @ Moved.
    
    ldr r0, =WALKRUN_STATE
    ldrb r0, [r0, #5]
    lsl r1, r0, #3 @ multiply by 0x24
    add r1, r0
    lsl r1, #2
    ldr r0, =NPC_STATES
    add r0, r1
    
    ldrb r2, [r0, #0x1C]
    sub r2, #0x14
    
    ldr r1, =LAST_MOVED_DIRECTION
    strb r2, [r1]
    
    @ End

    @ldr r2, =LAST_MOVED_DIRECTION
    @ldrb r2, [r2]
    mov r1, #0x10
    add r2, r1
    @mov r1, #MESSAGE_NONE
    @strb r1, [r3]
    
resume: 
    mov r0, r4
    mov r1, r7
    
    ldr r3, exit
    bx r3
    
.align 2
exit: .word 0x08062E3C + 1
