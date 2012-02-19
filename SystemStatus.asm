;;;;;OSAZUWA OMIGIE;;;;;;;;



		ORG	$1000			;data area

message:	FCC	"The result is not:"		; string: display message
Result:         DW  	$32				; your result variable is this one; store the result here
;TerminateString DB      0

window_S:		FCC	"window: "              
TerminateString	DB	0
temperature_S:		fcc	"temperature: "
Terminate2	DB	0
alarm_S			fcc 	"alarm: "
T_string2	DB	0
keysPressed_S		fcc 	"Keys Pressed: "
T_string3	DB	0
window_open:		fcc	"(open)"
win_status		db	0
window_closed		fcc	"(closed)"
w_closed	db	0





;;*delays are implemented using pushes and pulls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;windows, temperature, alarm, keyspressed initialized with values;;;;;;;;;;;;;;;;;;

windows:	db	%00000010
temperature:	db	%01000010  
alarm:		db	%11110010
keyspressed:	dw	%1100001100000101

char_1:		dw	$3100
char_0:		dw	$3000	

newline:	dw	$0A00
testWait	db	$00




;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN PROGRAM;;;;;;;;;;;;;;;;;;;;;;;

		ORG	$4000			;program area

main:
		LDS	#$3DFF			;initialize stack pointer (details later)
		
		
		

		
		;;;;;;;;;;TEST1;;;;;;;;;;;;;;;;;
		;;;passing arguments into the functions by address (placing them on the stack)
		ldy 	#keysPressed		;load the address of keysPressed into Y 
		pshy				;push content of y onto the stack
		
		ldy 	#alarm			;;load the address of alarm into Y
		pshy				;push content of y onto the stack

		ldy	#temperature		;;load the address of keysPressed into Y
		pshy 				;push content of y onto the stack

		ldd 	#windows		;;load the address of windows into D  (call policy: 1st argument must first be stored in D)
		
			
		

		jsr	displaySystemStatus	;return address will be stored on stack, and the PC will next contain the first instruction in displaySystemStatus
		leas	8,sp   ;upon return of the subroutine call, deallocate variable from the stack 
		;;;;;;;END OF TEST1;;;;;;;;;;;;;;;;;

		

		jsr 	print_newLine  ;leave a line between both test results when printing on the terminal
		jsr 	print_newLine  ;leave another line between both test results when printing on the terminal
		



		;;;;;;;;;;;;;;;;;;;;;;;TEST 2;;;;;;;;;;;;;;;;;;;;;;;
		
		ldd #1
		std counter		;reset the counter to 1
	
		ldd	#$4000		;load D with hex value 4000
		std 	keysPressed	;store content of D in variable keysPressed

		ldab 	#$00		;load B with 0
		stab 	alarm		;store content of B in variable alarm 

		ldab 	#$f0		;load B with hex value f0
		stab	temperature	;store content of B in variable temperature

		ldab 	#$80		;load B with hex value 80
		stab	windows		;store content of B in variable windows		

		;;;passing arguments into the functions by address
		ldy 	#keysPressed		;load the address of keysPressed into Y 
		pshy				;push content of y onto the stack
		
		ldy 	#alarm			;;load the address of alarm into Y
		pshy				;push content of y onto the stack

		ldy	#temperature		;;load the address of keysPressed into Y
		pshy 				;push content of y onto the stack

		ldd 	#windows		;;load the address of windows into D  (call policy: 1st argument must first be stored in D)

		jsr	displaySystemStatus	;return address will be stored on stack, and the PC will next contain the first instruction in displaySystemStatus
		leas	8,sp   ;upon return of the subroutine call, deallocate variable from the stack 	

		;;;;;;;;;;END OF TEST2;;;;;;;;;;;;;;;;;;;;



		jsr 	print_newLine  ;leave a line between both test results when printing on the terminal
		jsr 	print_newLine  ;leave another line between both test results when printing on the terminal
		

		;;;;;;;;;;TEST 3;;;;;;;;;;;;;;;;;;;;;
		ldd #1
		std counter		;reset the counter to 1
	
		ldd	#$8000		;load D with hex value 8000
		std 	keysPressed	;store content of D in variable keysPressed

		ldab 	#$71		;load B with hex value 71
		stab 	alarm		;store content of B in variable alarm 

		ldab 	#$1f		;load B with hex value 1f
		stab	temperature	;store content of B in variable temperature

		ldab 	#$4f		;load B with hex value 4f
		stab	windows		;store content of B in variable windows		

		;;;passing arguments into the functions by address
		ldy 	#keysPressed		;load the address of keysPressed into Y 
		pshy				;push content of y onto the stack
		
		ldy 	#alarm			;;load the address of alarm into Y
		pshy				;push content of y onto the stack

		ldy	#temperature		;;load the address of keysPressed into Y
		pshy 				;push content of y onto the stack

		ldd 	#windows		;;load the address of windows into D  (call policy: 1st argument must first be stored in D)

		jsr	displaySystemStatus	;return address will be stored on stack, and the PC will next contain the first instruction in displaySystemStatus
		leas	8,sp   ;upon return of the subroutine call, deallocate variable from the stack 	

		;;;;;;;;;;;;END OF TEST3



		bra *       ;end of program.


displaySystemStatus:
		
		pshd			;push the 1st argument onto the stack	
		
		pshx			;Save X. X will be used as our base pointer. 
		
		;;at this point the element at the top of the stack is X

		tfr 	sp,x		; inorder to use X as our base pointer, we copy the current the current position of the stack into X

		;;Call policy: register X must be preserved 
		leas	-6,sp		;allocate local variables


		
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		;pshx
		jsr dispWindow	;display "window: <binary value> (open/close)" on the terminal
		jsr dispTemp    ;display "Temperature: <binary value>" on the terminal
		jsr dispAlarm   ;display "Alarm: <binary value>" on the terminal
		jsr dispKP	;display "keysPressed: <binary value>" on the terminal

		tfr	x,sp		;deallocates local variables leaving only register X ontop of the stack 

		;;;We remove X and the 1st argument from ontop the stack so we can return successfully to main
		pulx			;restore X
		leas	2,sp		;Remove the first argument from ontop of the stack

		;;At this point the return address is on top of the stack 
		rts			;Now we can continue from main subroutine
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






counter		dw 0	;initialize our counter as 0
		



;;;;;;;;;;;;;;display "WINDWOW: <VALUE>;;;;;;;;;;;;;;;;;

dispWindow:	
		
		;create a local copy of the windows passed. That way we are able to modify our local copy 
		;during display of the value
		std -2,x     ;; we copy the first argument &windows into a local variable
		;;stack @ index x-2 now contains address of windows
		
		;std -4,x    ;;we make a copy here also so that we can manipulate this later on when checking if window is open/close
		
		ldd [-2,x]    
		
		std -4,x





		ldy counter	;here our counter is initialised as 0

		
		
		jsr	print_windows		;;first, print "window"
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

windowString:		
	
		cpy #8;;;check if register y==8
		
		beq done_dispWindow ;;;if it is then branch to done_dispWindow: 
		

		;;stack index x-2 contains a copy of the address of windows. Thus we need to manipulate
		;;the specific value in that address conatined in x-2 of the stack  
		asl [-2,x]      ;this may be similar to *((x--)--) << 1 
		
		



		
		
		bcs	print_1			;;;branch to print_1 if carry flag is set
		bcc 	print_0		;;;branch always to print_0 if not







windowString_cont:
		ldy counter
		iny 		;;after return, increment our index register X 
		sty counter

		bra   	windowString 	;always branch to windowString

				
	;;;;;;;;;;;;;;;;;;;;;;;;;print "windows";;;;;;;;;;;;;;;;;;;;;;;;;
print_windows:
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;;Sets up SCI0 with baud rate specified in register D
		LDY	#window_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
print_1:
		
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;;Sets up SCI0 with baud rate specified in register D
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	windowString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
print_0:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	windowString_cont
		
		



done_dispWindow:	
		jsr check_win_status
		rts

check_win_status:  ldab -4,x ;windows ;[-4,x]
		   andb #%00000001  ;we mask all other bits to see value of LSB (determines open/close)
		   cmpb #%00000001
		   ;bcs print_win_open ;if it is set then windows are open
		   bne print_win_close ;else windows are closed
		   beq print_win_open
print_win_open:
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#window_open		;output the message
		JSR	putStr_sc0
		jsr 	print_strTerminate
		;bra	windowString_cont
		rts				;;returns to done_dispWindow subroutine

print_win_close: 
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#window_closed	;output the message
		JSR	putStr_sc0
		jsr 	print_strTerminate
		;bra	windowString_cont
		rts			;;returns to done_dispWindow subroutine


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;display "TEMPERATURE: <VALUE>";;;;;;;;;;;;;;;;;

dispTemp:	
		jsr	print_newLine

		ldy #0
		sty counter
		movw 6,x -2,x
		;ldd 6,x
		;std -2,x

		jsr	print_Temperature		;;first, print "window"

		

		;bsr	print_strTerminate
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

TempString:		
	
		cpy #8;;;check if register x==8
		
		beq done_dispTemp ;;;if it is then branch to done_dispWindow: 
		
		;ldb 	#$32
		;addb 	windows
		;ldab	temperature		;load the windows value in B
		asl	[-2,x]			;and do an arithmetic shift left of B
		;stab	temperature 
		
		bcs	printT_1			;;;branch to print_1 if carry flag is set
		bcc 	printT_0		;;;branch always to print_0 if not

TempString_cont:
		ldy counter 
		iny 		;;after return, increment our index register X 
		sty counter
		bra   	TempString 	;always branch to windowString

				
	;;;;;;;;;;;;;;;;;;;;;;;;;print "temperature";;;;;;;;;;;;;;;;;;;;;;;;;
print_Temperature:
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#temperature_S		;display "temperature" on terminal
		JSR	putStr_sc0
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printT_1:
		
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	TempString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;




		;;;;;;;;;;;;;;;;;;;;;;;;;;;


		;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
	
printT_0:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	TempString_cont
		
		



done_dispTemp:	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




print_newLine:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#newline		;output the message
		JSR	putStr_sc0
		rts

print_strTerminate:	
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#TerminateString 		;output the message
		JSR	putStr_sc0
		rts





;;;;;;;;;;;;;;display "ALARM: <VALUE>;;;;;;;;;;;;;;;;;

dispAlarm:	
		
		jsr	print_newLine

		ldy #0
		sty counter    ;initializing our counter to zero


		movw 8,x -2,x     ;copy the alarm value into a local variable which we would need to shift for displaying bits
		;ldd 6,x
		;std -2,x

		jsr	print_Alarm		;;first, print "alarm: "

		

alarmString:		
	
		cpy #8;;;check if register y==8
		
		beq done_dispAlarm ;;;if it is then branch to done_dispWindow: 
		

		;;stack index x-2 contains a copy of the address of windows. Thus we need to manipulate
		;;the specific value in that address conatined in x-2 of the stack  
		asl [-2,x]      ;this may be similar to *((x--)--) << 1 
			
		
		bcs	printA_1			;;;branch to print_1 if carry flag is set
		bcc 	printA_0		;;;branch always to print_0 if not


alarmString_cont:
		ldy counter
		iny 		;;after return, increment our index register X 
		sty counter
		bra   	alarmString 	;always branch to windowString

				
	;;;;;;;;;;;;;;;;;;;;;;;;;print "windows";;;;;;;;;;;;;;;;;;;;;;;;;
print_Alarm:
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#alarm_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printA_1:
		
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	alarmString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
printA_0:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	alarmString_cont
		


done_dispAlarm:	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;;;;;;;;;;;;;;display "KEYSPRESSED: <VALUE>;;;;;;;;;;;;;;;;;

dispKP:	
		
		jsr	print_newLine

		ldy #0
		sty counter    ;initializing our counter to zero


		movw 10,x -2,x     ;copy the alarm value into a local variable which we would need to shift for displaying bits
		
		;ldd 6,x
		;std -2,x

		jsr	print_KeysPressed		;;first, print "KeysPressed: "

		

KPString:		
	
		cpy #16;;;check if register y==8
		
		beq done_dispKP ;;;if it is then branch to done_dispWindow: 
		

		;;stack index x-2 contains a copy of the address of windows. Thus we need to manipulate
		;;the specific value in that address conatined in x-2 of the stack  
		ldd [-2,x]      ;this may be similar to *((x--)--) << 1 
		asld
		std [-2,x]
		



		
		
		bcs	printK_1			;;;branch to print_1 if carry flag is set
		bcc 	printK_0		;;;branch always to print_0 if not







KPString_cont:
		ldy counter
		iny 		;;after return, increment our index register X 
		sty counter
		bra   	KPString 	;always branch to windowString

				
	;;;;;;;;;;;;;;;;;;;;;;;;;print "windows";;;;;;;;;;;;;;;;;;;;;;;;;
print_KeysPressed:
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#keysPressed_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printK_1:
		
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	KPString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
printK_0:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	KPString_cont
		
		



done_dispKP:	rts






	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#include "DP256reg.asm"
#include "sci0api.asm"

		END