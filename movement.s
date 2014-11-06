.include "config.s"

.align 2
.thumb
.thumb_func

@ This is the main movement hook. It will simply move the following NPC in the
@ same direction that the player last moved, resulting in a delayed mimic. 
@ The hook also copies the player's current movement type, so that the overworld
@ is always one step behind the player. 

main:
    mov r2, r0
    mov r2, r1
    sub r1, #0x14
    
    ldr r2, =(LAST_MOVED_DIRECTION)
    ldrb r2, [r2]
    add r2, #0x10
    
    ldr r3, =FOLLOW_MESSAGE
    ldrb r1, [r3]
    cmp r1, #MESSAGE_NONE
    bne handle_message
    
continue_checking:  
    @ Lets determine the movement type
    @ Note that these might be accurate. I will be doing more testing later
    ldr r3, =WALKRUN_STATE
    ldrb r3, [r3]
    
    @ Check if running
    mov r1, #STATE_RUNNING
    and r1, r3
    cmp r1, #0
    bne state_running
    
    @ Check if sliding (ice)
    mov r1, #STATE_SLIDING
    and r1, r3
    cmp r1, #0
    bne state_running
    
    b resume
    
handle_message:
    @ Only handle the message if we're moving
    ldr r0, =WALKRUN_STATE
    ldrb r0, [r0, #3] 
    cmp r0, #0
    beq continue_checking
    
    cmp r1, #MESSAGE_HOP
    beq message_hop
    
    @ We cannot handle this message, so pretend we never jumped to the message
    @ handler
    b continue_checking
    
message_hop:
    mov r1, #MESSAGE_NONE
    strb r1, [r3]

    mov r1, #0x74
    add r2, r1
    b resume
    
    
state_running:
    mov r3, #0x7C @#0xD (0x1D - 0x10)
    add r2, r3
    b resume

state_sliding:
    mov r3, #0x4
    add r2, r3
    
resume:    
    mov r1, r7
    mov r0, r4
    
    ldr r3, return
    bx r3

.align 2
store: .word 0x02036E35
return: .word 0x08062A00 + 1

memcpy:
    ldr r3, =(0x081E5E78 + 1)
    bx r3

