org 0x0100
	jmp start
	
	
clrscr:
	push es 
	push ax 
	push di 
	mov ax, 0xb800
	mov es, ax 
	mov di, 0 

	mov ax, 0x7720
	mov cx, 2000
	cld
	rep stosw

	pop di 
	pop ax 
	pop es 
	
	ret
	


welcome_screen:
	pusha
	call clrscr


	mov ax, 0xb800
	mov es, ax

	mov ah, 0x71
	mov al, '*'
	mov di, 0
	mov cx, 80
	rep stosw

	mov cx, 50
.l1:				;same loop to print both left and right  side
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 162
	loop .l1

	mov di, 3840
	mov cx, 80
	rep stosw

	mov ax, welcome
	push word 1976
	push ax
	call printstr

	mov ax, easy
	push word 2456
	push ax
	call printstr

	mov ax, hard
	push word 2936
	push ax
	call printstr

	

	popa
	ret


endscreen:
	pusha
	call clrscr


	mov ax, 0xb800
	mov es, ax

	mov ah, 0x71
	mov al, '*'
	mov di, 0
	mov cx, 80
	rep stosw

	mov cx, 50
.l1:				;same loop to print both left and right  side
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 162
	loop .l1

	mov di, 3840
	mov cx, 80
	rep stosw

	mov ax, endmsg
	push word 1988
	push ax
	call printstr
	popa
	ret	



	printstrt:
	push bp
	mov bp, sp
	pusha
	
	push ds
	pop es
	mov di,[bp+4]
	mov cx, 0xffff
	xor al,al
	repne scasb
	mov ax, 0xffff
	sub ax, cx
	dec ax
	jz diet
	
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]
	mov si, [bp+4]
	mov ah, 0x07
	cld
	nextchart:
		lodsb
		stosw
		loop nextchart
diet:
		popa
		pop bp
		ret 4
	
	printnum2: push bp 
              mov  bp, sp 
              push es 
              push ax 
              push bx 
              push cx 
              push dx 
              push di 
 
              mov  ax, 0xb800 
              mov  es, ax             ; point es to video base 
              mov  ax, [bp+6]         ; load number in ax 
              mov  bx, 10             ; use base 10 for division 
              mov  cx, 0              ; initialize count of digits 
 
nextdigit2:   mov  dx, 0              ; zero upper half of dividend 
              div  bx                 ; divide by 10 
              add  dl, 0x30           ; convert digit into ascii value 
              push dx                 ; save ascii value on stack 
              inc  cx                 ; increment count of values  
              cmp  ax, 0              ; is the quotient zero 
              jnz  nextdigit2          ; if no divide it again 
 
              mov  di, [bp+4]          ; point di to 70th column 
 
nextpos2:      pop  dx                 ; remove a digit from the stack 
              mov  dh, 0x07           ; use normal attribute 
              mov  [es:di], dx        ; print char on screen 
              add  di, 2              ; move to next screen location 
              loop nextpos2            ; repeat for all digits on stack 
 
              pop  di 
              pop  dx 
              pop  cx 
              pop  bx 
              pop  ax 
			  pop  es 
              pop  bp 
              ret  4 
timer:
              push ax 
              inc  word [cs:tickcount]; increment tick count
			  cmp word [cs:tickcount],18
			  jne dafa
			  inc word [cs:seconds]
			  push word [cs:seconds]
			  push word 280
              call printnum2         ; print tick count
			  cmp word[cs:seconds],60
			  je m1
			  mov word[cs:tickcount],0
			  jmp dafa
			  m1:
			  inc word[cs:minutes]
			  push word[cs:minutes]
			  push word 274
			  call printnum2
			  push word 278
			  mov ax,semi
			  push ax
			  call printstrt
			  push word 280
			  mov ax,spstring
			  push ax
			  call printstrt
			  mov word[cs:tickcount],0
			  mov word[cs:seconds],0
 dafa:
              mov  al, 0x20 
              out  0x20, al           ; end of interrupt 
 
              pop  ax 
              iret                    ; return from interrupt 
print_timer:
   pusha
   mov ax,PrintTimer
   push word 260
   push ax 
   call printstr
   popa 
   ret
print_title:
	pusha

	mov ax, title
	push word 230
	push ax
	call printstr

	popa
	ret

printgrid:
	pusha
	mov ax, 0xb800
	mov es, ax

;-------------thin cols-------------
	mov ah, 0x70
	mov al, '.'
	mov si, 840
	mov dx, 8 ;bkaya 8 rows par krna
.L00:
	mov di, si ; di mey ko mnai us location pr point kr diya jahn printing honi
	mov cx,  18

.L01:
	mov [es:di], ax
	;add di, 2
	;mov [es:di], ax
	add di, 160
	loop .L01
	add si, 12 ; next row location calculated
	dec dx ; decrementing dx or checking if dots are completely printed on rows
	cmp dx, 0
	jnz  .L00




;------------thin rows-------------
	mov ah,  0x70
	mov al, '-' 
	mov si, 990
	mov dx, 9
.L02:
	mov di, si
	mov cx,  53

.L03:
	mov [es:di], ax
	add di, 2
	loop .L03
	add si, 320 ; ab agli row mei dotted line print and so on counter set to 53 takai puri row mei na kry 53 tak kry bas
	dec dx ;dx has number of rows
	cmp dx, 0
	jnz  .L02


;-------------thick cols-------------
	mov ah, 0x00
	mov al, ' '
	mov si, 668
	mov dx, 4 ; 4 coulmns 
.L0:
	mov di, si
	mov cx,  19

.L1:
	mov [es:di], ax
	;add di, 2
	;mov [es:di], ax
	add di, 160
	loop .L1
	add si, 36
	dec dx
	cmp dx, 0
	jnz  .L0


;------------thick rows-------------
	mov ah,  0x00
	mov al, ' ' 
	mov si, 670
	mov dx, 4 ; 4 rows mei krni thin
.L2:
	mov di, si
	mov cx,  53

.L3:
	mov [es:di], ax
	add di, 2
	loop .L3
	add si, 960
	dec dx
	cmp dx, 0
	jnz  .L2

	
	popa
	ret



printnum:
	 push bp 
	 mov bp, sp 
	 push es 
	 push ax 
	 push bx 
	 push cx 
	 push dx 
	 push di 
	 push si
	 mov si, 0
	 mov ax, 0xb800 
	 mov es, ax ; point es to video base 
	 mov ax, [bp+4] ; load number in ax 
	 cmp ax, 0
	 je _pexit
	 
	 mov cx, 0 ; initialize count of digits 
nextdigit:
	 mov bx, 10
	 mov dx, 0 ; zero upper half of dividend 
	 div bx ; divide by 10 
	 add dl, 0x30 ; convert digit into ascii value 
	 push dx ; save ascii value on stack 
	 inc cx ; increment count of values 
	 cmp ax, 0 ; is the quotient zero 
	 jnz nextdigit ; if no divide it again 
	 mov di,  [bp+6]; 
nextpos:
	 pop dx ; remove a digit from the stack 
	 mov dh, 0x74 ; use normal attribute 
	 mov [es:di], dx ; print char on screen 
	 add di, 2 ; move to next screen location 
	 ;inc si
	 loop nextpos ; repeat for all digits on stack
_pexit:
	 pop si
	 pop di 
	 pop dx 
	 pop cx 
	 pop bx 
	 pop ax 
	 pop es 
	 pop bp 
	 ret 4
	 
	 
	;delay mnai is liyey dala hai takai aik noticeable change aye jab sound mnai krwani ya grid pr number move krwana wahan delay zaroori
delay:
	push cx
	mov cx, 0xffff
.d:  nop ; extends loop excecution time
	loop .d
	pop cx
	ret
	
	

; Helper function to introduce a delay using the system timer interrupt
get_random_delay:
    pusha
    mov ah, 00h              ; BIOS: Get system time
    int 1Ah                  ; Call BIOS timer interrupt
    ; Add some random delay based on system ticks, useful for randomization
    mov cx, dx               ; System time (ticks) in dx
    and cx, 0x0F             ; Use only lower bits for some randomness
.delay_loop:
    loop .delay_loop         ; Simple loop for delay
    popa
    ret


GenRandNum:
	push bp
	mov bp,sp;
	push cx
	push ax
	push dx;

	MOV AH, 00h ; interrupts to get system time
	INT 1AH ; CX:DX now hold number of clock ticks since midnight
	mov ax, dx
	xor dx, dx
	mov cx, 2;
	div cx ; here dx contains the remainder of the division - from 0 to 9
	mov word [randNum],dx;

	pop dx;
	pop ax;
	pop cx;
	pop bp;
	ret

	 
print_index_values:
	pusha
	;row values:
	
	mov di, 514
	mov ax, 1
	mov cx, 9
.l1:	
	push di
	push ax
	call printnum
	add di, 12
	inc ax
	loop .l1
	
	;col values:
	mov di, 824
	mov ax, 1
	mov cx, 9
.l2:	
	push di
	push ax
	call printnum
	add di, 320
	inc ax
	loop .l2
	
	
	
	popa
	ret

	
	
print_stats:
	pusha
	
	mov ax, moves
	push word 1260
	push ax
	call printstr
	
	mov di, 1272
	push di
	mov ax, [move_count]
	push ax
	call printnum
	
	mov ax, score
	push word 1900
	push ax
	call printstr
	mov di, 1912
	push di
	mov ax, [score_count]
	push ax
	call printnum

	mov ax, mistakes
	push word 2540
	push ax
	call printstr
	mov di, 2552
	push di
	mov ax, [mistake_count]
	push ax
	call printnum

	mov ax, undo
	push word 3202
	push ax
	call printstr

;-----row input------
	push word 1122
	mov ax, str1
	push ax
	call printstr

;-----col input------
	push word 1762
	mov ax, str2
	push ax
	call printstr

;------board input------
	push word 2402
	mov ax, str3
	push ax
	call printstr
	
	
	popa
	ret
	

initialize_random_mask:
	pusha

	mov ax, waitmsg ;loading please wait wala msg
	push word 3416
	push ax
	call printstr

	mov si, 0
	mov cx, 81 ;9*9 ki grid to mnai counter 81 ka rkh diya
.l1:
	call GenRandNum ;hard level mey mnai random mask generate krwaye har dafa
	mov ax, [randNum]
	mov [mask+si], ax
	add si, 2
	call delay ; yahan mnai delay is liyey dala kiu key gen random number mey clockticks 12345 aisa numbers generate krwati jayen gy to speed my random number nahi aye gy baar baar yahi rhy ga to delay mnai is liyey dala  takai baar baar differenet ho generate
	loop .l1
	popa
	ret

	;jahan 1 wahan print only
print_board_values:
	pusha
	mov ax, 0xb800
	mov es, ax
	

	mov di, 834
	mov si, 0
	mov dx, 0
.L1:
	mov cx, 9 ; no of rows and cols
.l1:	
	mov ax, [mask+si]
	cmp ax, 0
	je .skip_val
	mov ax, [board+si]
	add ax, '0' ;same as 0x30 in book converting into asci
	mov ah,  0x70
	mov [es:di], ax
.skip_val:
	add si, 2
	add di, 12
	loop .l1

	add di, 212 ;agli row pr aja
	inc dx
	cmp dx, 9
	jl .L1
	
	popa
	ret
	
;copied from book
printstr:
	push bp
	mov bp, sp
	pusha
	
	push ds
	pop es
	mov di,[bp+4]
	mov cx, 0xffff
	xor al,al
	repne scasb
	mov ax, 0xffff
	sub ax, cx
	dec ax
	jz d
	
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]
	mov si, [bp+4]
	mov ah, 0x71
	cld
	nextchar:
		lodsb
		stosw
		loop nextchar
d:
		popa
		pop bp
		ret 4
	

clrtext:
	push bp
	mov bp,sp
	pusha
	    push ds
		pop es
		mov di,[bp+4]
		mov cx, 0xffff
		xor al,al
		repne scasb
		mov ax, 0xffff
		sub ax, cx
		dec ax
		jz exitclr
	mov cx, ax
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+6]
	mov ah,0xff
	mov al,20h
	cld
	rep stosw
	exitclr:popa
	pop bp
	ret 4

;------SOUND---------
sound:
	push bp
	mov bp, sp
	push ax

	mov al, 182
	out 0x43, al
	mov ax, [bp + 4]   ; frequency
	out 0x42, al
	mov al, ah
	out 0x42, al
	in al, 0x61
	or al, 0x03
	out 0x61, al
call delay ; wrna bari speed mey kam ho ga aur pata bhi ni lgyga
call delay
call delay
call delay
call delay
call delay
	in al, 0x61

	and al, 0xFC
	out 0x61, al

	pop ax
	pop bp
    ret 2
;agr filled nahi ho gi tab me us pr input krwa skta wrna nahi to mnai aik boolean flag rkh liya agr 0 hai to khali hai ya 0 pra hva mask mei wahan value rkhwa skta
check_line_fill:
    pusha

;-----row check----
    mov si, 0                 
    mov dx, 0                 
.L1:
    mov cx, 9                 
    mov bx, si                              
.l1:
    mov ax, [mask+bx]         
    cmp ax, 0
    je .not_complete_row      
    add bx, 2                 
    loop .l1
    mov word [line_flag], 1   
    jmp .exit
.not_complete_row
    mov word [line_flag], 0   
.skip_row_check
    inc dx                    
    add si, 18                
    cmp dx, 9
    jl .L1      

;-----col check---
    mov si, 0                 
    mov dx, 0                 
.L2:
    mov cx, 9                 
    mov bx, si                             
.l2:
    mov ax, [mask+bx]         
    cmp ax, 0
    je .skip_col_check      
    add bx, 18                
    loop .l2
    mov word [line_flag], 1    
    jmp .exit    
.skip_col_check:
    inc dx                    
    add si, 2                 
    cmp dx, 9
    jl .L2                    

.exit:
    popa
    ret
;agr aik bhi one aa gaya to game over nahi
check_game_over:
	pusha

	mov si, 0
	mov cx, 81
.l1
	mov ax, [mask+si]
	cmp ax, 0
	je .exit
	add si, 2
	loop .l1
	mov word [game_end], 1
.exit:
	popa
	ret


;--------------------------INPUT CODE-----------------------------------
get_input:
	push bp
	mov bp, sp
	pusha
	
.input:
	xor ax, ax
	mov ah, 0
    int 0x16
	cmp ah, 0x1                 ; Esc key
    je near exit
	cmp al, 'Z'
	je .undo
	cmp al, 'z'
	je .undo
    cmp al, 0x31                
    jl .input ;0x31 is ascii of 1 agr to agr is sy koi chota number enter krta user to dubara .input label pr dubara input lo
	cmp al, 0x39 ;agr 9 sy bara hai to same scene
	jg .input
	
    sub al, 0x30 ;jaisa key 0x31-0x30 to 0x01 numeric value 1 print ho rahi
	mov ah, 0
	mov word [bp+6], ax
	mov di, [bp+4]
	push di
	push ax
	call printnum

	jmp .exit

.undo:
	mov word [undo_flag], 1

.exit:	
	popa
	pop bp
	ret 2
calculate_move_index:
	pusha
	xor ax, ax             
    mov al, [row_value]
	dec al	;to adjust as per 0 based array indexes      
    mov bx, 18        ;Each row in the grid spans 18 bytes in memory (9 columns × 2 bytes per cell).     
    mul bx                 

    xor bx, bx              
    mov bl, [col_value] ;adjust as 0 based index pr ley jaa
	dec bl  ;to  adjust as per 0 based array indexes      
    shl bx, 1               

    add ax, bx             

    mov [board_index], ax

	popa
	ret

undo_move:
	pusha

	mov bx, [board_index]
	mov word [mask+bx], 0 ;hide 

	push word 166
	push word [mask+bx]
	call printnum

	push word 170
	push word [board+bx]
	call printnum

	mov ax, [score_count_copy]
	mov [score_count], ax

	mov ax, [mistake_count_copy]
	mov [mistake_count], ax

	mov ax, [move_count]
	cmp  ax, 0
	je .next
	dec word [move_count]
.next:
	push 2000
 	call sound

	mov word [undo_flag], 0

	popa
	ret
make_move:
	pusha

	mov bx, [board_index]
	mov ax, [mask+bx]
	cmp ax, 0 ;agr location khali wahan move ho skta
	je .next
	mov ax, warning
	push word 2880 ; slow motion mey krna
	push ax
	call printstr
	call delay 
	call delay
	call delay
	mov ax, warning
	push word 2880
	push ax
	call clrtext	
	jmp .exit

.next:
;only hard coded value can come
	mov ax, [board+bx]
	mov dl, [input_value]
	mov dh, 0
	cmp  ax, dx
	je .valid
	mov ax, error
	push word 2722
	push ax
	call printstr
	call delay 
	call delay
	call delay
	mov ax, error
	push word 2722
	push ax
	call clrtext
	mov ax, [mistake_count]
	mov [mistake_count_copy], ax
	inc word [mistake_count]	; mistake me aik add
	jmp .exit
.valid:
	mov word [mask+bx], 1
	mov ax, [score_count]
	mov [score_count_copy],  ax
	add word [score_count], 10 ;score mey 10 add agr valid move hai
.exit:
	popa
	ret

;--------------------------------------MAIN PROGRAM-----------------------------------------------	
start:
;----To generate a randomized game---
	
	
	call welcome_screen
	mov ah, 0
    int 0x16
	cmp al, '1'
	je .hard
	jmp game_loop
.hard:
	call initialize_random_mask
game_loop:

	call clrscr
	 xor  ax, ax 
     mov  es, ax             ; point es to IVT base 
     cli                     ; disable interrupts 
     mov  word [es:8*4], timer; store offset at n*4 
     mov  [es:8*4+2], cs     ; store segment at n*4+2 
     sti              
	call print_title
	call print_timer
	call print_index_values
	call printgrid 
	call print_stats
	call print_board_values

	;---------input row, col, board value...Check undo flag after each input------------
	push word [row_value]
	push word 1134
	call get_input
	pop word [row_value]

    mov ax, [undo_flag]
	cmp  ax, 0
	je .next1
	call undo_move
	jmp  game_loop

.next1:
	push word [col_value]
	push word 1774
	call get_input
	pop word [col_value]

    mov ax, [undo_flag]
	cmp  ax, 0
	je .next2
	call undo_move
	jmp  game_loop

.next2:
	push word [input_value]
	push word 2414
	call get_input
	pop word [input_value]


	mov ax, [undo_flag]
	cmp  ax, 0
	je .move
	call undo_move
	jmp  game_loop
.move:
	call calculate_move_index
	call make_move
	inc word [move_count]

	call check_line_fill

	mov ax, [line_flag]
	cmp ax, 1
	jne .next3
	push 2000
 	call sound
	mov word [line_flag], 0
.next3:
	call check_game_over 

	mov ax, [game_end]
	cmp ax, 1
	jne game_loop

exit:
	call print_board_values	
	call endscreen
 	mov cx, 2
.bye:
 	push 2000
 	call sound
 	push 2500
 	call sound
	push 2700
 	call sound
 	loop .bye
	
	mov ax, 0x4c00
	int 0x21
	

difficulty: db 0
moves: db "Moves: ", 0
title: db "S U D O K U", 0
mistakes:  db "Wrong: ", 0
str1: db "Row: ", 0
str2: db "Col: ", 0
str3: db "VAL: ", 0
welcome: db "Welcome to Sudoku Game!", 0
endmsg: db "Game Over!", 0
easy: db "Default: Easy mode", 0
hard: db "1. Hard mode", 0
waitmsg: db "Loading...Please wait", 0
continue:  db "Press any key to continue...", 0
error: db "Wrong Value", 0
warning: db "Box not empty", 0
undo: db "Undo: Z", 0
randNum: dw 0
score: db "Score: ", 0

undo_flag: dw 0
line_flag: dw 0
row_value: dw 0
col_value: dw 0
input_value: dw 0
board_index: dw 0
move_count: dw 0
score_count: dw 0
mistake_count: dw 0
score_count_copy: dw 0
mistake_count_copy: dw 0
game_end: dw 0
PrintTimer: dw "Timer:",0
tickcount:dw 0
seconds:dw 0
minutes: dw 0
spstring:db"  ",0
semi:db" : ",0
board:dw	5, 3, 4, 6, 7, 8, 9, 1, 2, \
			6, 7, 2, 1, 9, 5, 3, 4, 8, \
			1, 9, 8, 3, 4, 2, 5, 6, 7, \
			8, 5, 9, 7, 6, 1, 4, 2, 3, \
			4, 2, 6, 8, 5, 3, 7, 9, 1, \
			7, 1, 3, 9, 2, 4, 8, 5, 6, \
			9, 6, 1, 5, 3, 7, 2, 8, 4, \
			2, 8, 7, 4, 1, 9, 6, 3, 5, \
			3, 4, 5, 2, 8, 6, 1, 7, 9


mask:dw		1, 1, 0, 0, 0, 0, 1, 1, 1, \
			0, 1, 0, 1, 0, 0, 0, 0, 1, \
			0, 0, 1, 0, 1, 1, 0, 0, 0, \
			1, 0, 0, 0, 1, 0, 0, 0, 1, \
			0, 1, 0, 1, 0, 0, 1, 1, 1, \
			1, 0, 1, 1, 0, 0, 0, 1, 0, \
			0, 1, 0, 0, 0, 1, 1, 1, 0, \
			1, 0, 0, 0, 1, 0, 0, 0, 1, \
			0, 1, 1, 1, 1, 1, 0, 1, 0
