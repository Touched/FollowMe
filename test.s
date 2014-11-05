.include "config.s"

.align 2
.thumb
.thumb_func

@ When colliding with an object, the NPC will fall back into look mode. We need
@ this hook to make sure they continue to face the direction that they should be
@ facing, rather than looking in the direction that the player is attemptiing
@ to move.

main:
    ldr r0, =(LAST_MOVED_DIRECTION)
    ldrb r2, [r0]
    mov r0, r4
    mov r1, r7

    ldr r3, exit
    bx r3


.align 2
exit: .word 0x08062A4E + 1
