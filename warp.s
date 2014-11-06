.include "config.s"

.text
.align 2
.thumb_func

@ Don't get too excited, it's just a test.
@ 080570EC 

main:
    add sp, #4
    push {r6}
    sub sp, #4

    @ Show the follower OW
    @ TODO We should load this data (map, bank, local id) from somewhere
    bl show_specfic
    
    @ Get a pointer to the NPC state of the follower
    ldr r3, =NPC_STATES
    lsl r2, r0, #3
    add r2, r0
    lsl r2, #2
    add r5, r3, r2
    
    @ Get the NPC state of the player
    ldr r2, =WALKRUN_STATE
    ldrb r2, [r2, #5]
    lsl r1, r2, #3
    add r1, r2
    lsl r1, #2
    add r4, r3, r1
    
    @ Load the direction of the player
    ldrb r0, [r4, #0x18] @ Direction
    lsl r0, #0x1C @ Get the actual direction
    lsr r0, #0x1C
    
    ldr r1, =LAST_MOVED_DIRECTION
    @strb r0, [r1]
    
    @ Invert the facing direction
    bl direction_reverse
    
    @ Save the player's current direction as the direction they last moved
    @ This should fix the direction the follower moves after the warp
    mov r6, r0
    
    ldrh r0, [r4, #0x14] 
    ldrh r1, [r4, #0x16] 
    bl cur_mapdata_block_role_at
    
    @ Load the coordinates of the player and store them in the space allocated
    @ on the stack. We need pointers to these values.
    mov r1, sp @ u16 *x
    ldrh r3, [r4, #0x14] 
    strh r3, [r1]
    add r2, r1, #2 @ u16 *y
    ldrh r3, [r4, #0x16] 
    strh r3, [r2]
    
    mov r3, r0 
    cmp r3, #0x69
    beq skip_move
    
    @ Find the coordinate of behind the player
    mov r0, r6
    bl numbers_move_direction
    
skip_move:
    @ Here we move the NPC
    @ If you're using map coordinates (from Advance Map), you need to add 7
    @ to each coordinate. This does not need to be done, as the coordinates
    @ in the NPC state have this done already.
    
    mov r0, r5
    mov r2, sp
    ldrh r1, [r2]
    ldrh r2, [r2, #2]
    bl npc_move
    
    
    @ Bdfd
    mov r0, #0
    strb r0, [r5]
    
    add sp, #4
    pop {r6}
    pop {r4-r5, pc}
    
show_specfic:
    push {lr}
    mov r0, #2
    mov r1, #0
    mov r2, #3
    bl show_sprite   
    pop {pc} 
    
npc_move:
    ldr r3, =(0x0805F724  + 1)
    bx r3
    
direction_reverse:
    ldr r3, =(0x08064480 + 1)
    bx r3
    
numbers_move_direction:
    ldr r3, =(0x08063A20 + 1)
    bx r3
    
cur_mapdata_block_role_at:
    ldr r3, =(0x08058F78 + 1)
    bx r3

set_state:
    ldr r3, =(0x08063CA4 + 1)
    bx r3
    
show_sprite:
    @ r0 - Local ID
    @ r1 - Map
    @ r2 - Bank
    @ Retuns - NPC State Index (Probably)

    ldr r3, =(0x0805E898 + 1)
    bx r3
