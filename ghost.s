.include "config.s"

.text
.align 2
.thumb_func

@ A second collision problem. This arises because the player is unable to walk
@ through NPCs. However, we want the player to be able to walk over NPCs with
@ this behaviour, so we need a hook.

@ Location: 0806395C

main:
    lsl r0, #0x18
    cmp r0, #0
    beq do_loop
    
    @ Usually, we would return 1 here, as there is an npc at this position.
    @ However, we're going to check for the behaviour as well
    
    lsl r0, r4, #3 @ multiply by 0x24
    add r0, r4
    lsl r0, #2
    ldr r1, npc_states
    add r0, r1
    ldrb r1, [r0, #0x6]
    
    @ Check for the sprite behaviour
    mov r0, #FOLLOW_BEHAVIOUR
    cmp r1, r0
    beq check_collider_is_player
    
return_blocked:
    mov r0, #1
    b return
    
do_loop:
    ldr r0, exit
    bx r0
    
check_collider_is_player:
    ldr r1, npc_states
    sub r0, r6, r1 @ Subtract npc_states from the collider npc_state
    
    @ Assuming we were passed a valid NPC state, this will give us the index
    @ It's hacky, but that's what all of this is ;)
    lsr r0, #5 @ Integer division by 20
    sub r0, #1 
    
    @ Get the NPC ID of the player
    ldr r1, =WALKRUN_STATE
    ldrb r1, [r1, #5] 
    
    @ Only allow passage if the player is the one that is colliding
    cmp r0, r1
    beq return_blocked
    
return_clear:
    mov r0, #0
    
return:
    pop {r4-r7, pc}
    
.align 2
exit: .word 0x0806396C + 1
npc_states: .word 0x02036E38
