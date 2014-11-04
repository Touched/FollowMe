.include "config.s"

.text
.align 2
.thumb_func

@ The default functionality causes the overworld to mimic the players facing
@ direction, even if they have not moved (). This looks odd, and is thus 
@ undesirable. This hook disables that functionality.

@ Location: 08062990

@ Directions: 0: Down, 1: Up, 2: Left, 3: right

main:
    ldr r0, =(0x02036E35)
    ldrb r0, [r0]
    
    @ Account for the apply movement oddities (delay movements, etc)
    cmp r0, #0x1C
    blt to_dir
    
    @ Subtract that value
    mov r1, #0x1C
    sub r0, r1
    
to_dir:
    @ Mod by 4 to get the direction of the movement
    mov r1, #0x4
    bl mod
    
    @ Arrange parameters for function call after exit
    mov r2, r0
    mov r0, r4
    mov r1, r5
    
    ldr r3, exit
    bx r3
    
mod:
    ldr r3, =(0x081E4684 + 1)
    bx r3
    
.align 2
exit: .word 0x0806299A + 1

