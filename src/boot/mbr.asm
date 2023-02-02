[bits 16]
[org 0x7c00]

; Credits to Frank Rosner (frosner)
; https://github.com/FRosner
; https://dev.to/frosnerd/

; Load the kernel
KERNEL_OFFSET equ 0x1000

; BIOS sets boot drive to 'dl'
mov [BOOT_DRIVE], dl

; Setup stack
mov bp, 0x9000
mov sp, bp

call load_kernel
call switch_to_32bit

jmp $

%include "disk.asm"
%include "gdt.asm"
%include "switch-to-32bit.asm"

[bits 16]

load_kernel:
    mov bx, KERNEL_OFFSET ; bx is the destination
    mov dh, 2             ; dh is the number of sectors
    mov dl, [BOOT_DRIVE]  ; dl is the disk
    call disk_load
    ret

[bits 32]
BEGIN_32BIT:
    call KERNEL_OFFSET ; give control to the kernel
    jmp $              ; repeat in case kernel returns

; Boot drive variable
BOOT_DRIVE db 0

; padding
times 510-($-$$) db 0

; magic number
dw 0xaa55