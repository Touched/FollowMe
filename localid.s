.include "config.s"

.align 2
.thumb
.thumb_func

@ Many script functions allow space for a local ID ("Person event no" in Advance
@ Map). Apart from the usual numbers, we also have the unique numbers for the 
@ player (0xFF) and the camera (0x7F). This hook adds an extra special number
@ for the following NPC.

main:
    ldrb r0, [r3]
    lsl r0, #0x1F
    cmp r0, #0
    beq do_loop
    
    @ Start of hook
    @ Check if we're actually looking for the follower 
    cmp r5, #FOLLOWER_LOCAL_ID
    
    @ We're not, so ignore the check
    bne not_follower_local_id
    
    @ Check for the follower behaviour
    ldrb r0, [r3, #6] @ Load the behaviour byte
    cmp r0, #FOLLOW_BEHAVIOUR
    beq found_follower
    @ End of hook

not_follower_local_id:
    ldrb r0, [r3, #0x8]
    cmp r0, r5
    bne do_loop
    ldr r0, exit
    bx r0
    
do_loop:
    ldr r0, loop_exit
    bx r0
    
found_follower:
    mov r0, r1 @ Return the counter
    ldr r1, exit_return
    bx r1
    
.align 2
loop_exit: .word 0x0805E030 + 1
exit: .word 0x0805E01C + 1
exit_return: .word 0x0805E03C + 1
