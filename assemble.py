#!/usr/bin/python3
    
import os
import subprocess
import sys
import shutil

OBJCOPY = 'arm-linux-gnueabi-objcopy'
AS = 'arm-linux-gnueabi-as'
CC = 'arm-linux-gnueabi-gcc-4.7'
CXX = 'arm-linux-gnueabi-g++'

def assemble(assembly, rom, offset, *args):
	subprocess.check_output([AS, '-mthumb'] + list(args) + [assembly])
	subprocess.check_output([OBJCOPY, '-O', 'binary', 'a.out', 'a.bin'])
	os.remove('a.out') 
	with open(rom, 'rb+') as out, open('a.bin', 'rb') as ins:
		out.seek(offset)
		out.write(ins.read())
		out.write(bytes(100))
		
shutil.copyfile('BPRE0.gba', 'test.gba')

def hook(file, rom, space, hook_at, register=0, *args):
    assemble(file, rom, space, *args)
    with open('test.gba', 'rb+') as rom:
        # Align 2
        if hook_at & 1:
            hook_at -= 1
            
        rom.seek(hook_at)
        
        register &= 7
        
        if hook_at % 4:
            data = bytes([0x01, 0x48 | register, 0x00 | (register << 3), 0x47, 0x0, 0x0])
        else:
            data = bytes([0x00, 0x48 | register, 0x00 | (register << 3), 0x47])
            
        space += 0x08000001
        data += (space.to_bytes(4, 'little'))
        rom.write(bytes(data))
        
with open('test.gba', 'rb+') as rom:
    # Byte Patches
    reflect = [0x062986, 0x0629D6, 0x062A8E, 0x062B46, 0x062BFE, 0x062CAE, 0x062CFE, 0x062DB6]
    for item in reflect:
        rom.seek(item)
        rom.write((0x2102).to_bytes(2, 'little'))
        
    hook('movement.s', 'test.gba', 0x800000, 0x0629F6, 2)
    #hook('hopecho.s', 'test.gba', 0x810000, 0x062DE4, 2)
    hook('ledge.s', 'test.gba', 0x810000, 0x062E32, 2)
    hook('collision.s', 'test.gba', 0x820000, 0x062A10, 3)
    hook('ghost.s', 'test.gba', 0x830000, 0x06395C, 3)
    hook('facing.s', 'test.gba', 0x840000, 0x062990, 2)
    hook('test.s', 'test.gba', 0x850000, 0x062A44, 2)
    
    hook('localid.s', 'test.gba', 0x860000, 0x05E00E, 0)
