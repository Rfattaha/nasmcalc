
%include 'function.asm'

section .data
    StartMessage db '1 - Addition , 2 - Subtraction , 3 - Multiplication, 4 - Division , 5 - Reminder , 6 - Increment , 7 - Decrement , 8 - Exit', 0h
    selectOp db 'Select Operation : ', 0h
    firstNumber db 'Enter the first number: ', 0h
    secondNumber db 'Enter the second number: ', 0h  
    resultNumber db 'Result: ', 0h,
    incORdec db 'Enter number: ', 0h,    
section .bss          
   num1 resb 6
   num2 resb 6
   result resb 6
   temp resb 1

section .text
   global _start

%macro write_string 1
    mov     eax, %1
    call 	print_string
%endmacro

%macro write_result 0
    push    eax
    write_string resultNumber
    pop     eax
    call    print_integer
    call    string_new_line
%endmacro

%macro input 1
	mov		ecx, %1  
	mov		edx, 6
	call    scan_user_input
%endmacro

%macro shortcut_for_take_number 0
	write_string firstNumber
        input   num1

        mov 	edx, num1
        call    conver_int
        mov     ebx, eax
        push    ebx

        write_string secondNumber
        input   num2

        mov 	edx, num2
        call    conver_int
        pop     ebx
%endmacro

%macro shortcut_for_inc_dec 0
	write_string incORdec
        input   num1
        mov   edx, num1
        call   conver_int
%endmacro

_menu:
    write_string StartMessage
    call string_new_line
    write_string selectOp
    ret

_start:
    call _open_menu
_open_menu:
   call    _menu
   input   temp
   mov 	edx, temp
   call    conver_int
   cmp     eax, 8
   je      _exit

   cmp     eax, 7
   je      _DEC

   cmp     eax, 6
   je      _INC

   cmp     eax, 5
   je      _reminder

   cmp     eax, 4
   je      _div

   cmp     eax, 3
   je      _mul

   cmp     eax, 2
   je      _sub

   cmp     eax, 1
   je      _sum

   loop    _open_menu
_sum:
        shortcut_for_take_number
        add     eax, ebx
        write_result
        jmp     _open_menu
_sub:
        shortcut_for_take_number
        mov     edx, eax
        mov     eax, ebx
        sub     eax, edx

        write_result
        jmp     _open_menu
_mul:
        shortcut_for_take_number
        mul     ebx
        write_result
        jmp     _open_menu
_div:
        shortcut_for_take_number
        mov     ecx, eax
        mov     eax, ebx
        mov     edx, 0
        div     ecx

        write_result
        jmp     _open_menu
_reminder:
    shortcut_for_take_number
    mov ecx, eax
    mov eax, ebx
    mov edx, 0
    div ecx
    mov eax, edx

    write_result
    jmp    _open_menu
_INC:
    shortcut_for_inc_dec
    inc     eax

    write_result
    jmp     _open_menu
_DEC:
    shortcut_for_inc_dec
    dec eax

    write_result
    jmp _open_menu
_exit:
    call  exit