SYSSIZE = 0x3000



.globl begtext,begdata,begbss,endtext,enddata,endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

SETUPLEN  = 4
BOOTSETG  = 0x07c0
SETUPSETG = 0x07e0

entry _start
_start:
!print msg on screen
	
	mov ah,#0x03
	xor bh,bh
	int 0x10
	
	mov cx,#42
	mov bx,#0x0007
	mov ax,#BOOTSETG  		!data & code segment in the same arem
	mov es,ax
	mov bp,#msg1
	mov ax,#0x1301
	int 0x10

load_setup:
	mov dx,#0x0000
	mov cx,#0x0002
	mov bx,#0x0200
	mov ax,#0x0200+SETUPLEN
        int 0x13
	jnc ok_load_setup
	mov dx,#0x0000
	mov ax,#0x0000
	int 0x13
	j   load_setup

ok_load_setup:
	jmpi	0,SETUPSETG

msg1:
	.byte 13,10
	.ascii	"Hello OS world,My name is huangliqun"
	.byte 13,10,13,10

.org 510
boot_flag:
	.word 0xAA55
.text
endtext:
.data
enddata:
.bss
endbss:
