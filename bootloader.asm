BITS 16
org 0x7c00

_bitSetup:
        xor ax, ax
        mov ah, 0x00
        mov al, 0x03
        int 0x10
_startBoot:
        mov si, IntroString
        call _printString
        mov si, LoadingMessage
        call _printString
        call _LaunchProgram
        jmp $
        
_LaunchProgram:
.readAttempt:
        mov si, ReadingDisk
        call _printString

        mov bx, 0x8000
        mov es, bx
        mov bx, 0x0000
        
        mov ah, 0x02    ;Read func
        mov al, 0x03    ;Sectors
        mov ch, 0x00    ;Cylinder
        mov cl, 0x02    ;Sector
        mov dh, 0x00    ;Head
        mov dl, 0x00    ;Drive
        int 0x13
        jc .readAttempt ;Jump back if error.
        jmp 0x8000:0x0000
        ret

_printString:
        mov ah, 0x0e
        xor bl, bl
.loop:
        lodsb
        test al, al
        jz .done
        int 0x10
        jmp .loop
.done:
        ret

        IntroString db "Tonic's Memory Loader", 0x0d, 0x0a, 0
        LoadingMessage db "Will attempt to load image to memory address 0x8000", 0x0d, 0x0a, 0
        ReadingDisk db "Disk read attempt...", 0x0d, 0x0a, 0
        ReadFailed db "Disk read failure", 0x0d, 0x0a, 0
        DiskWarn db "Disk failure warning. Disk may be near or at end of life. Operation aborted.", 0x0d, 0x0a, 0
        DiskLoaded db "Disk read success. Now launching stored program.", 0x0d, 0x0a, 0

        times 510-($-$$) db 0x00
        dw 0xAA55
