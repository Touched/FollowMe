.include "config.s"

.align 2
.thumb
.thumb_func

@ 01: Still/Walking
@ 41: Sliding
@ 81: Running
@ 02: Bike

main:
    mov r2, r0
    ldr r0, store
    ldrb r1, [r0]
    strb r2, [r0]
    mov r2, r1
    sub r1, #0x14
    
    ldr r2, =(LAST_MOVED_LOCATION)
    ldrb r2, [r2]
    add r2, #0x10
    
    @ Lets determine the movement type
    ldr r3, =(0x02037078)
    ldrb r3, [r3]
    
    @ Check if running
    mov r1, #0x80
    and r1, r3
    cmp r1, #0
    bne state_running
    
    @ Check if sliding
    mov r1, #STATE_SLIDING
    and r1, r3
    cmp r1, #0
    bne state_running
    
    b storeit
    
state_running:
    mov r3, #0xD
    add r2, r3
    b storeit

state_sliding:
    mov r3, #0x4
    add r2, r3

storeit:
    ldr r1, store
    add r1, #0x2
    strb r2, [r1]
    
resume:    
    mov r1, r7
    mov r0, r4
    
    ldr r3, return
    bx r3

lockplayer:
    b storeit

.align 2
store: .word 0x02036E35
return: .word 0x08062A01
walkrun: .word WALKRUN_STATE

mod:
    ldr r3, =(0x081E4684 + 1)
    bx r3

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
