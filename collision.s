.include "config.s"

.text
.align 2
.thumb_func

@ Collision is horrible. The regular collision fucks up everything: the NPC 
@ won't be able to follow the player closely, and will instead leave 1 tile
@ between itself and the player. Disabling collision is an imperfect solution,
@ as it will cause the NPC to move over the player if the player bumps into 
@ something. Thus the reason for this hook. This hook bases collision detection 
@ off the player's position, thus only moving the NPC if the player has moved. 
@ Otherwise, nothing will block the way of the following NPC.

@ Location: 08062A10

main:
    mov r3, r6
    bl collision
    
    lsl r0, #0x18
    cmp r0, #0
    bne way_blocked
    ldr r0, =(0x08062A1C + 1)
    bx r0
    
way_blocked:
    @ Blocks the way of the following NPC
    ldr r0, =(0x08062A3E + 1)
    bx r0
    
collision:
    push {r4-r5, lr}
    mov r5, r4
    ldr r4, npc_states @ Player NPC State
    
    ldr r0, walkrun_state
    ldrb r1, [r0, #5]
    lsl r0, r1, #3 @ * 0x24
    add r0, r1
    lsl r0, #2
    add r4, r0
        
    @ Store target X and Y pos on stack
    sub sp, #8
    mov r1, sp
    add r2, r1, #2
    ldrh r0, [r4, #0x14] 
    strh r0, [r1]
    ldrh r0, [r4, #0x16] 
    strh r0, [r2]
    
    ldrb r0, [r4, #0x18] @ Direction byte
    lsl r0, #0x1C @ Get the actual direction
    lsr r0, #0x1C
    bl move_coords_direction
    
    @ Get block role
    mov r3, sp
    ldrh r1, [r3] @ X
    ldrh r2, [r3, #2] @ Y
    
    ldrb r0, [r4, #0xB]
    
    @bl get_behaviour_byte_at
    bl height_check
    
    mov r1, #1
    eor r0, r1
    
    cmp r0, #0
    bne collision_return
    
    @ Store the player's direction iff we have moved
    ldrb r2, [r4, #0x18] @ Direction byte
    lsl r2, #0x1C @ Get the actual direction
    lsr r2, #0x1C
    ldr r1, =(LAST_MOVED_DIRECTION) 
    sub r2, #1
    strb r2, [r1]
   
collision_return:
    add sp, #8
    pop {r4-r5, pc}
    
height_check:
    ldr r3, =(0x080681B0 + 1)
    bx r3
    
collision_func:
    @ Player collision
    ldr r4, =(0x080636AC + 1)
    bx r4
    
player_get_pos_to:
    ldr r3, =(0x0805C538 + 1)
    bx r3
    
move_coords_direction:
    ldr r3, =(0x08063A20 + 1)
    bx r3
    
get_behaviour_byte_at:
    ldr r3, =(0x08058F78 + 1)
    bx r3

is_there_a_npc_to_interact_with:
    ldr r3, =(0x08063904 + 1)
    bx r3
    
.align 2
npc_states: .word 0x02036E38
walkrun_state: .word 0x02037078
saveblock1: .word 0x03005008
