SYSSIZE = 0x3000



.globl begtext,begdata,begbss,endtext,enddata,endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

SETUPLEN = 4
BOOTSETG = 0x07c0
INITSETG = 0x9000

entry _start
_start:
!print msg on screen
	
	mov ah,#0x03
	xor bh,bh
	int 0x10
	
	mov cx,#25
	mov bx,#0x0007
	mov ax,cs  		!data & code segment in the same arem
	mov es,ax
	mov bp,#msg2
	mov ax,#0x1301
	int 0x10

	mov ax,#INITSETG
	mov ds,ax
	
	mov ah,#0x03		!cursor position
	xor bh,bh
	int 0x10
	mov [0],dx

	mov ah,#0x88
	int 0x15		!read mem size
	mov [2],ax

    mov ax,#0x0000
	mov ds,ax
	lds si,[4*0x41]
	mov ax,#INITSETG
	mov es,ax
	mov di,#0x0080
	mov cx,#0x10
	rep
	movsb

	mov ax,#0x0000
	mov ds,ax
	lds si,[4*0x46]
	mov ax,#INITSETG
	mov es,ax
	mov di,#0x0090
	mov cx,#0x10
	rep
	movsb


	!print hardware param
	mov ax,cs
	mov es,ax
	mov ax,#INITSETG
	mov ds,ax

    !init ss:sp
    mov ax,#INITSETG
    mov ss,ax
    mov sp,#0xFF00
	

	mov ah,#0x03
	xor bh,bh
	int 0x10
	mov cx,#18
	mov bx,#0x0007
	mov bp,#msg_cursor
	mov ax,#0x1301
	int 0x10
	mov dx,[0]
	call print_hex

    !print mem
    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#11
    mov bx,#0x0007
    mov bp,#msg_mem
    mov ax,#0x1301
    int 0x10
    mov dx,[2]
    call print_hex

    !Add KB
    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#2
    mov bx,#0x0007
    mov bp,#msg_kb
    mov ax,#0x1301
    int 0x10

    !print hd param
    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#8
    mov bx,#0x0007
    mov bp,#msg_cycles
    mov ax,#0x1301
    int 0x10
    mov dx,[0x0080]
    call print_hex
    
    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#8
    mov bx,#0x0007
    mov bp,#msg_heads
    mov ax,#0x1301
    int 0x10
    mov dx,[0x0082]
    call print_hex


    mov ah,#0x03
    xor bh,bh
    int 0x10
    mov cx,#10
    mov bx,#0x0007
    mov bp,#msg_sectors
    mov ax,#0x1301
    int 0x10
    mov dx,[0x008e]
    call print_hex

    call inf_loop

print_hex:
	mov cx,#4

print_digit:
	rol dx,#4
	mov ax,#0x0e0f
	and al,dl
	add al,#0x30
	cmp al,#0x3a
	jl  outp
    add al,#0x07

outp:
	int 0x10
	loop print_digit
	ret

inf_loop:
	jmp inf_loop
msg2:
	.byte 13,10
	.ascii	"Now we are in SETUP"
	.byte 13,10,13,10

msg_cursor:
	.byte 13,10
	.ascii	"Cursor position:"

msg_mem:
    .byte 13,10
    .ascii  "Mem size:"

msg_kb:
    .ascii  "KB"

msg_cycles:
     .byte 13,10
     .ascii "Cycls:"

msg_heads:
     .byte 13,10
     .ascii "Heads:"

msg_sectors:
     .byte 13,10
     .ascii "Sectors:"

.org 510
boot_flag:
	.word 0xAA55
.text
endtext:
.data
enddata:
.bss
endbss:
