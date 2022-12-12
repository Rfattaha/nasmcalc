STDOUT 		equ 1
SYS_EXIT 	equ 1
SYS_WRITE 	equ 4
SYS_READ 	equ 3
STDIN 		equ 0
SYS_EXE     equ 11
%define SYSCALL int 0x80
%define NULL 0h

section .data   
	nLine 	  db   '',0xA,0xD
;------------------------------
; calculates the length of the given string
;------------------------------
length:
	push 	ebx			
	mov		ebx, eax	    ; pointing to the same address
    .next:
        cmp		byte [eax], 0	; zero is the end of the string
        jz		.end			; if it's the end of the string, jump the end
        inc		eax				; if the condition is not satisfied, increment 1 byte
        jmp		.next			; loop
    .end:
        sub		eax, ebx		; eax is increased so eax - ebx will give the length (byte difference between addresses) of the string. 
        pop 	ebx				
        ret

;------------------------------
; read user input
;------------------------------
scan_user_input:
	mov		eax, SYS_READ
	mov		ebx, STDIN
	SYSCALL
	ret
;------------------------------
; print new line
;------------------------------
string_new_line:
	mov		ecx, nLine
	mov		edx, 1
	mov     ebx, STDOUT
    mov     eax, SYS_WRITE
    SYSCALL
	ret

;------------------------------
; print procedure
; Note: Requires 0Ah (null byte at the end of the message)
;------------------------------
print_string:

    .prepare:
        push    edx
        push    ecx
        push    ebx
        push    eax
        call    length
    .print:
        mov     edx, eax        ; strlen returned the length in eax register, so we must move to edx
        pop     eax
        mov     ecx, eax        ; we popped the eax and it holds our message
        mov     ebx, STDOUT
        mov     eax, SYS_WRITE
        SYSCALL
    .end:
        pop     ebx
        pop     ecx
        pop     edx
        ret


; Another conver string input to integer
;atoi:
;xor eax, eax ; zero a "result so far"
;.top:
;movzx ecx, byte [edx] ; get a character
;inc edx ; ready for next one
;cmp ecx, '0' ; valid?
;jb .done
;cmp ecx, '9'
;ja .done
;sub ecx, '0' ; "convert" character to number
;imul eax, 10 ; multiply "result so far" by ten
;add eax, ecx ; add in current digit
;jmp .top ; until done
;.done:
;ret

conver_int:
    .prepare:
        push    edx
        push    ecx
        xor     eax, eax 
    .convert:
        movzx   ecx, byte [edx] ; get a character from the string
        cmp     ecx, '0'        ; is the character valid
        jb      .finish
        sub     ecx, '0'        ; convert to number
        imul    eax, 10         ; to have decimal value we must multiply by ten
        add     eax, ecx        ; add current digit
        inc     edx             ; we must increase edx to get next character
        jmp     .convert        ; till conditions are satisfied
    .finish:
        pop     ecx
        pop     edx
        ret

;------------------------------
; procedure to print integers
;------------------------------
print_integer:
    
    .prepare:
        push    eax             
        push    ecx             
        push    edx             
        push    ebx        
        mov     ecx, 0          ; counter
 
    .divide:
        inc     ecx             ; increment counter
        mov     edx, 0          ; empty edx
        mov     ebx, 10         ; mov 10 into ebx
        div     ebx             ; divide eax by ebx
        add     edx, '0'         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
        push    edx             ; push edx (string representation of an intger) onto the stack
        cmp     eax, 0          ; can the integer be divided anymore?
        jnz     .divide      ; jump if not zero to the label divideLoop
    
    .iterate_and_print:
        dec     ecx             ; count down each byte that we put on the stack
        mov     eax, esp        ; mov the stack pointer into eax for printing
        call    print_string     ; call our string print function
        pop     eax             ; remove last character from the stack to move esp forward
        cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
        jnz     .iterate_and_print       ; jump is not zero to the label printLoop

    .end:
        pop     ebx             ; restore esi from the value we pushed onto the stack at the start
        pop     edx             ; restore edx from the value we pushed onto the stack at the start
        pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
        pop     eax
        ret

;------------------------------
; exit
;------------------------------
exit:
	mov		eax, SYS_EXIT
	SYSCALL
	ret