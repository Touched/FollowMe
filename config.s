@ Configuration settings for the hack
@ I'll probably but some ifdefs for conditional assembly (easy porting)

@ The behaviour number for the follow me, same as in Advance Map
.equ FOLLOW_BEHAVIOUR, 0x35 


@ Config. Todo
.equ GAMECODE_BPRE, 0
.equ GAMECODE_BPEE, 1

.equ GAMECODE, 1

.if GAMECODE==0
.fail 0
.endif

@ FR
.equ NPC_STATES, 0x02036E38


.equ WALKRUN_STATE, 0x02037078
.equ STATE_RUNNING, 0x80
.equ STATE_SLIDING, 0x40
.equ LAST_MOVED_LOCATION, 0x020370BE
