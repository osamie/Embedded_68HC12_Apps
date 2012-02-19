
;;;;;;;;;Alarm disarmed : green LED
;;;;;;;Alarm armed: Red LED
;;;;;;

	ORG $1000

message:	FCC	"The result is: "		; string: display message
Result:         DW  	$3000				; your result variable is this one; store the result here
Result_str	rmb	5



windows	db	%11111111   ;;;windows: the LSB = 1 means the windows are open

alarm	db	%11110001          ;;;;The MSB = 1 means the alarm is armed

keysPressed	dw	%0100000010000001    ;;;the 2nd MSB = 1 means the infrared sensor key is pressed

char_1:		dw	$3100
char_0:		dw	$3000	

cond1		fcc	"windows break - in"
TerminateString DB      0
cond2		fcc	"break-in"
tem_s	db 	0
cond3		fcc	"windows open"
tem_s2	db	0
cond4		fcc	"person in the room"
tem_s3	db	0
newline:	dw	$0A00



window_S:		FCC	"window: "
TermStr	DB	0
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
test1		fcc	"---------Test 1------------"
test2		fcc	"---------Test 2------------"
test3		fcc	"---------Test 3------------"



;;;;Alarm armed: RED LED:
;;;;Alarm disarmed: GREEN LED




;;;;;;;;;;;;;;;;;;PARAMETERS OF THE displaysystemstatus FUNCTION;;;;;;;;;;;;;;;;;;;;;;;;;
;;windows, temperature, alarm, keyspressed
;; %0000 0000
;windows:	db	%00000010
temperature:	db	%01000010  
;alarm		db	%11110010
;keyspressed	dw	%1000001100000000


;newline:	dw	$0A00



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN SUBROUTINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;LDS	#$3DFF			;initialize stack pointer (details later)
	;ldy	#keysPressed
	;pshy

	;ldy	#alarm
	;pshy

	;ldd	#windows
	;jsr	intrusion

	;jsr 	print_newLine


	org $4000
	;;;;;;;;;;;;;;;;;;;;;;;;MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main:	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TEST 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jsr 	print_newLine   ;print a new line here
	
	
        ;;;;;;;;;;displaySystemStatus-TEST1;;;;;;;;;;;;;;;;;
		ldd #1
		std counter		;reset the counter to 1
	
		ldd	#$4000		;load D with hex value 4000
		std 	keysPressed	;store content of D in variable keysPressed

		ldab 	#$80		;load B with 0
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

	;;;;;;;END OF displaySystemStatus-TEST1;;;;;;;;;;;;;;;;;


		

	jsr 	print_newLine 		;new line input on the terminal


	;;;;;;;;;;;;;;;;;;INTRUSION-TEST1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
	ldab    #%11111111		;load B with f1
	stab	windows		;;store content of B in variable windows

	ldab 	#%11110001		;load B with f1
	stab 	alarm		;store content of B in variable alarm

	ldd	#$4000		;load D with hex value 4000
	std 	keysPressed	;store content of D in variable keysPressed
	
	;;;;;;;;now CALL "boolean intrusion (byte &windows, byte &alarm, int &keysPressed)";;;;;;;
	;LDS	#$3DFF			;initialize stack pointer (details later)
	ldy 	#keysPressed		;load the address of keysPressed into Y 
	pshy				;push content of y onto the stack

	ldy 	#alarm			;;load the address of alarm into Y
	pshy				;push content of y onto the stack

	ldd	#windows	;;load the address of windows into D  (call policy: 1st argument must first be stored in D)
	jsr	intrusion	;;call intrusion subroutine

	;;;;;print result of the subroutine here;;;;;;;;;;;;;;;;;;;;;;
	jsr 	print_newLine   ;print a new line here
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#message		;display "the result is: "
	JSR	putStr_sc0		;;takes a character in b and displays it

	
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#Result_str		;display "the result is: "
	JSR	putStr_sc0	         ;takes a character in b and displays it
	;;;;;;;;;;;;;;;finished printing subroutine result;;;;;;;;;;;;;;;;;



	leas 8,sp
	
	jsr 	print_newLine   ;new line input in terminal

;;;;;;;;;;;;;;;;;;;;;;;;;;END OF INTRUSION-TEST1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;DELAY BY DOING PUSHES AND PULLING VALUES OF THE STACK BEFORE THE NEXT TEST
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula	
	

;;;;;;;;;;;;;;TEST 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	jsr 	print_newLine   ;new line input in terminal
	
	;;;;;;;;;;displaySystemStatus-TEST2;;;;;;;;;;;;;;;;;

	ldd #1
	std counter		;reset the counter to 1
	ldd	#$4000		;load D with hex value 8000
	
	std 	keysPressed	;store content of D in variable keysPressed

	ldab 	#$f1		;load B with hex value 71
	stab 	alarm		;store content of B in variable alarm 

	ldab 	#$1f		;load B with hex value 1f
	stab	temperature	;store content of B in variable temperature

	ldab 	#$ff		;load B with hex value 4f
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

	;;;;;;;;;;END OF displaySystemStatus-TEST2;;;;;;;;;;;;;;;;;


	jsr 	print_newLine   ;new line input on the terminal


	;;;;;;;;;;;;;;;;;;INTRUSION-TEST2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;;;;;;;;now CALL "boolean intrusion (byte &windows, byte &alarm, int &keysPressed)";;;;;;;
	;LDS	#$3DFF			;initialize stack pointer (details later)

	ldab    #$ff		;load B with f1
	stab	windows		;;store content of B in variable windows

	ldab 	#$f1		;load B with f1
	stab 	alarm		;store content of B in variable alarm

	ldd	#$4000		;load D with hex value 4000
	std 	keysPressed	;store content of D in variable keysPressed


	;(push arguments onto the stack)
	ldy	#keysPressed	;load the address of keysPressed into Y
	pshy			;push content of y onto the stack

	ldy	#alarm		;;load the address of alarm into Y
	pshy			;push content of y onto the stack


	ldd	#windows	;;load the address of windows into D  (call policy: 1st argument must first be stored in D)
	jsr	intrusion	;;return address will be stored on stack, and the PC will next contain the first instruction in intrusion

	;;std Result_str

	;;;;;print result of the subroutine here;;;;;;;;;;;;;;;;;;;;;;
	jsr 	print_newLine   ;print a new line here
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#message		;display "the result is: "
	JSR	putStr_sc0	

	
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#Result_str		;display "the result is: "
	JSR	putStr_sc0	
	;;;;;;;;;;;;;;;finished printing subroutine result;;;;;;;;;;;;;;;;;

	leas 8,sp	;;deallocate variables from the stack
	
	jsr 	print_newLine   ;print a new line here
	
	;;;;;;;;;;;;;;;;;;END OF INTRUSION-TEST2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;END OF TEST 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;DELAY BEFORE THE NEXT TEST
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	
	psha
	pula
	psha
	pula




;;;;;;;;;;;;;;;;;;;;;;;TEST 3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	jsr 	print_newLine   ;new line input in terminal

	;;;;;;;;;;displaySystemStatus-TEST3;;;;;;;;;;;;;;;;;
	
	ldd #1
	std counter		;reset the counter to 1
	
	ldd	#$8000		;load D with hex value 4000
	std 	keysPressed	;store content of D in variable keysPressed

	ldab 	#$01		;load B with hex 81
	stab 	alarm		;store content of B in variable alarm 

	ldab 	#$f0		;load B with hex value f0
	stab	temperature	;store content of B in variable temperature

	ldab 	#$01		;load B with hex value 80
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


	;;;;;;;;;;END OF displaySystemStatus-TEST3;;;;;;;;;;;;;;;;;
	


	;;;;;;;;;;;;;;INTRUSION-TEST3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;jsr 	print_newLine   ;print a new line here
	
	
	;;;;;;;;now CALL "boolean intrusion (byte &windows, byte &alarm, int &keysPressed)";;;;;;;
	;LDS	#$3DFF			;initialize stack pointer (details later)

	ldab 	#$01		;load B with hex value 40
	stab	windows		;store content of B in variable windows	

	ldab 	#$01		;load B with hex value 81
	stab 	alarm		;store content of B in variable alarm

	ldd	#$8000		;load D with hex value 8000
	std 	keysPressed	;store content of D in variable keysPressed


	;;;;;start pushing arguments onto the stack;;;;;;;;;;;;
	ldy 	#keysPressed		;;;load the address of keysPressed into Y
	pshy				;push content of Y onto the stack
	
	ldy 	#alarm			;;load the address of alarm into Y
	pshy				;push content of y onto the stack

	ldd 	#windows		;;load the address of windows into D  (call policy: 1st argument must first be stored in D)
	jsr	intrusion		;return address will be stored on stack, and the PC will next contain the first instruction in displaySystemStatus

	;;;;;print result of the subroutine here;;;;;;;;;;;;;;;;;;;;;;
	jsr 	print_newLine   ;print a new line here
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#message		;display "the result is: "
	JSR	putStr_sc0		;takes a character in b and displays it	


	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#Result_str		;display "the result is: "
	JSR	putStr_sc0		;;takes a character in b and displays it

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	leas 8,sp
	

	


	jsr 	print_newLine   ;print a new line here

	;;;;;;;;;;;;;;;;;;;;;;;;END OF INTRUSION-TEST3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


















	
	bra	*


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;;;;;;;;;;;;;;;;;;;;;;;;;DISPLAY SYSTEM STATUS SUBROUTINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

displaySystemStatus:
		
		pshd			;save the 1st argument "byte &windows"	
		
		pshx			;Save X. Call policy:register X must be preserved. 

		tfr 	sp,x
		leas	-6,sp		;allocate local variables


		;;;;local variables;;;;;;;;;;
		
;w	dw	5

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
		;pshx
		jsr dispWindow
		jsr dispTemp
		jsr dispAlarm
		jsr dispKP

		tfr	x,sp		;deallocate local

		pulx			;restore X
		leas	2,sp		;Get rid of 1st argument "byte &windows"
		
		rts			;then return to main
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






counter		dw 0
		



;;;;;;;;;;;;;;display "WINDWOW: <VALUE>;;;;;;;;;;;;;;;;;

dispWindow:	
		
		;create a local copy of the windows passed. That way we are able to modify our local copy 
		;during display of the value
		std -2,x     ;; we copy the first argument &windows into a local variable
		;;stack @ index x-2 now contains address of windows
		
		;std -4,x    ;;we make a copy here also so that we can manipulate this later on when checking if window is open/close
		
		ldd [-2,x] 
		
		std -4,x     ;;we make a copy here also so that we can manipulate this later on when checking if window is open/close





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
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#window_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
print_1:
		
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	windowString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
print_0:	LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
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
		   bra print_win_open
print_win_open:
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#window_open		;output the message
		JSR	putStr_sc0
		jsr 	print_strTerminate
		;bra	windowString_cont
		rts				;;returns to done_dispWindow subroutine

print_win_close: 
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
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
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#temperature_S		;display "temperature" on terminal
		JSR	putStr_sc0
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printT_1:
		
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		
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
		
	
printT_0:	LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	TempString_cont
		
		



done_dispTemp:	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




print_newLine:	LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#newline		;output the message
		JSR	putStr_sc0
		rts

print_strTerminate:	
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#TerminateString 		;output the message
		JSR	putStr_sc0
		rts





;;;;;;;;;;;;;;display "ALARM: <VALUE>;;;;;;;;;;;;;;;;;

dispAlarm:	
		
		jsr	print_newLine

		ldy #0
		sty counter    ;initializing our counter to zero


		;movb [8,x] -2,x     ;copy the alarm value into a local variable which we would need to shift for displaying bits
		
		ldab [8,x]
		stab -2,x         ;copy the alarm value into a local variable which we would need to shift for displaying bits
		
		;ldd [8,x]
		;std -4,x     
		
		
		jsr	print_Alarm		;;first, print "alarm: "
		

alarmString:		
	
		cpy #8;;;check if register y==8
		
		beq done_dispAlarm ;;;if it is then branch to done_dispWindow: 
		

		;;stack index x-2 contains a copy of the address of windows. Thus we need to manipulate
		;;the specific value in that address conatined in x-2 of the stack  
		asl -2,x      ;this may be similar to *((x--)--) << 1 
			
		
		bcs	printA_1			;;;branch to print_1 if carry flag is set
		bcc 	printA_0		;;;branch always to print_0 if not


alarmString_cont:
		ldy counter
		iny 		;;after return, increment our index register X 
		sty counter
		bra   	alarmString 	;always branch to windowString

				
	;;;;;;;;;;;;;;;;;;;;;;;;;print "alarm: ";;;;;;;;;;;;;;;;;;;;;;;;;
print_Alarm:
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#alarm_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate

		
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printA_1:
		
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	alarmString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
printA_0:	LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	alarmString_cont
		


done_dispAlarm:	
		;jsr checkAlarm_Status 		
		rts

checkAlarm_Status:
	;;;check if alarm is armed, is armed as;;
		;movw 8,x -2,x    ;;copy alarm variable into a local variable
		
		;ldab [8,x]
		;stab -2,x    ;re assign this local variable which we would be masking to check the   
		
		ldab [6,x]	;;put the value in register b	
		andb #%10000000	  ;;mask all other bits to see the LSB in alarm
		cmpb #%10000000   ;;check if the alarm is on (i.e if the LSB is set)
		beq alarm_armed   
		bra alarm_disarmed 

alarm_armed:
	; setup port K with bits 0...3 as output pins (1 = output)
	movb #$FF,DDRK
	
	; Turn on RED LED  
	movb #$00, PORTK      ; all low = all off
	bset PORTK,#$21      ; turn on RED LED AND BUZZER

	pshx
	; Delay
	
	ldx #$FFFF
loop: 	psha
	pula
	psha
	pula
	dbne x, loop
	
	pulx

	; Turn off BUZZER,
	movb #$01,PORTK
	
	;;;first turn off all leds
	;;;turn on green led
	rts

alarm_disarmed:
	; setup port K with bits 0...3 as output pins (1 = output)
	movb #$0F,DDRK
	
	; Turn on green led  
	movb #$00, PORTK      ; all low = all off
	bset PORTK,#$08      ; turn on green LED

	pshx
	; Delay
	ldx #$FFFF
loop2: 	psha
	pula
	psha
	pula
	psha
	pula
	psha
	pula
	
	psha
	pula
	psha
	pula
	dbne x, loop2
	
	pulx

	; Turn off green LED,
	movb #$08,PORTK

	
	;;;first turn off all leds
	;;;turn on red led 
	
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










;;;;;;;;;;;;;;display "KEYSPRESSED: <VALUE>;;;;;;;;;;;;;;;;;

dispKP:	
		
		jsr	print_newLine

		ldy #0
		sty counter    ;initializing our counter to zero


		movw 10,x -2,x     ;copy the keyspressed value into a local variable which we would need to shift for displaying bits
		;ldd 6,x
		;std -2,x

		jsr	print_KeysPressed		;;first, print "alarm: "

		

KPString:		
	
		cpy #16;;;check if register y==8
		
		beq  done_dispKP ;;;if it is then branch to done_dispWindow: 
		

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
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#keysPressed_S		;output "windows"
		JSR	putStr_sc0
		jsr 	print_strTerminate
		
		rts

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



		;;;;;;;;;;;print value;;;;;;;;;;;;;;;;
printK_1:
		
		LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		
		;shift window value left once into C, and store updated value in windowString;;;;
		
		;;;load carry flag into  into Y;;;;;;;
		;;load C flag in Y and print it
		
		;check the counter to see if is equal to 8 ;;we are printing 8bits
		;if it is not jump back to print_Val

		
		LDY	#char_1		;output the message
		JSR	putStr_sc0
				
		bra 	KPString_cont
		;;;;;;;;;;;;;;;;;;;;;;;;;;;

		
	
printK_0:	LDD	#BAUD19K		;program SCI0's baud rate
		JSR	setbaud
		LDY	#char_0		;output the message
		JSR	putStr_sc0
		bra	KPString_cont
		
		



done_dispKP:	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



























	;org $4000



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INTRUSION SUBROUTINE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
intrusion:
		
	
	pshd 
	pshx
	tfr sp,x
	
	leas -6,sp
	
	;movw 2,x -2,x
	;td -2,x
	
	ldd #$3000	;initialise boolean return value as false/0
	
	jsr checkCond1    ;check for If the alarm is armed and the window is opened
	jsr checkCond2	  ;check if the alarm is armed and the "Infrared sensor" key is pressed	
	jsr checkCond3	  ;check if the alarm is off and the window is opened
	jsr checkCond4	  ;check if the alarm is off and the "Infrared sensor" key is pressed
	jsr checkAlarm_Status  ;check alarm status and turn on the buzzer accordingly
	

		;LDD	#BAUD19K		;program SCI0's baud rate
		;JSR	setbaud

		;LDY	-2,x		;output the message
		;JSR	putStr_sc0


	tfr x,sp
	pulx
	leas 2,sp

	ldd #$3100	  ;(boolean result) store ascii 1 in D to indicate success. 
	std Result_str 
	rts
	

;;;;;;;;;;;;check for "windows Break in" (i,e If the alarm is armed and the window is opened)
;;;windows opened: windows[LSB =1] && alarm is armed alarm[MSB=1]
checkCond1:  
	
	;copy the value of windows and do a mask to see only MSB 
	movw 2,x -2,x

checkCond1a:
	ldab [-2,x]
	andb #%00000001   ;mask to see only only the LSB of *windows
	cmpb	#%00000001 
	beq checkCond1b
	rts

checkCond1b:
	movw 6,x -2,x     	;local variable will now contain $alarm
	ldab [-2,x]		;put *alarm in register b	
	andb #%10000000 	;mask the MSB in B 
	cmpb #%10000000	
	beq display_Cond1
	rts	;return to start

display_Cond1:
	LDD	#BAUD19K		;program SCI0's baud rate
	JSR	setbaud
	LDY	#cond1		;output "windows"
	JSR	putStr_sc0
	jsr 	print_strTerminate

	rts

done_checkingCond1: rts  ;return to main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;check for "Break in" (i.e. If the alarm is armed and the "Infrared sensor" key is pressed)
;;;alarm is armed [MSB = 1] && Infrared sensor key pressed: keysPressed[MSB = 1]
checkCond2:  
	;copy the value of windows and do a mask to see only MSB 
	movw 6,x -2,x    ;create a copy of &alarm into a local variable 
	jsr checkCond2a
	rts   ;return to start subroutine


checkCond2a:  ; check to see if the alarm is armed, alarm [MSB =1]
	ldab [-2,x]	
	andb #%10000000   ;mask to see only only the MSB of alarm
	cmpb	#%10000000 
	beq checkCond2b
	rts


checkCond2b:  ;;;check if keysPressed[MSB = 1]
	movw 8,x -2,x
	ldd [-2,x]
	anda #%10000000		;mask the next 7 bits to see the value of the MSB
	cmpa #%10000000		;compare the MSB to see if it is turned on
	beq display_Cond2	;if it is 1, that means infrared sensor key has been pressed thus display "Break in"
	rts	;return to checkCond2

;;;;;;;;;;;;;;if Condition = true, display "Break in" on the terminal
display_Cond2:
	jsr	print_newLine 
	LDD	#BAUD19K		;program SCI0's baud rate
	JSR	setbaud
	LDY	#cond2		;output "Break in"
	JSR	putStr_sc0
	;jsr 	print_strTerminate

	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;check for "windows open" (i.e. If the alarm is off and the window is opened)
;;alarm is off: alarm[MSB=0] && windows opened: windows[LSB=1]
checkCond3:  
	;copy the value of windows and do a mask to see only MSB 
	movw 6,x -2,x
	jsr checkCond3a
	rts   ;return to start subroutine


checkCond3a:  ;;check if the alarm is off alarm[MSB=0]
	ldab [-2,x]	
	andb #%10000000   ;mask to see only only the MSB of alarm
	cmpb	#%00000000  ;check to see if the MSB=0 
	beq checkCond3b	   ;if it is, then go ahead and check the next condition	
	rts		;else, return to checkCond3 which in turn returns to start 

checkCond3b: ;;check if the window is opened windows[LSB=1]
	movw 2,x -2,x		;make a copy of &windows into a local variable
	ldab [-2,x]		;load the value in windows into register B
	andb #%00000001		;mask the first 7 bits to see the value of the LSB
	cmpb #%00000001		;now compare the LSB to 1 to see if it is turned on
	beq display_Cond3	;if it is 1, that means the window is opened thus display "windows open"
	rts	;return to checkCond3

;;;;;;;;;;;;if Condition3 above = true, display "windows open" on the terminal
display_Cond3:
	jsr	print_newLine 
	LDD	#BAUD19K		;program SCI0's baud rate
	JSR	setbaud
	LDY	#cond3		;output "windows open"
	JSR	putStr_sc0
	;jsr 	print_strTerminate

	rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;check for "Person in the room" (i.e. If the alarm is off and the "Infrared sensor" key is pressed)
;;alarm is off: alarm[MSB=0] && infrared sensor key pressed, keysPressed[MSB=1]
checkCond4:  
;copy the value of windows and do a mask to see only MSB 
	movw 6,x -2,x
	jsr checkCond4a
	rts   ;return to start subroutine

checkCond4a:  ;;check if the alarm is off alarm[MSB=0]
	ldab [-2,x]	
	andb #%10000000   ;mask to see only only the MSB of alarm
	cmpb	#%00000000  ;check to see if the MSB=0 
	beq checkCond4b	   ;if it is, then go ahead and check the next condition	
	rts		;else, return to checkCond4 which in turn returns to start 

checkCond4b:  ;;;check if keysPressed[second MSB = 1]
	movw 8,x -2,x
	ldd [-2,x]
	anda #$40		;mask the next 7 bits to see the value of the MSB
	cmpa #$40		;compare the 2nd MSB to see if it is turned on
	beq display_Cond4	;if it is 1, that means infrared sensor key has been pressed thus display "Person in the room"
	rts	;return to checkCond4

;;;;;;;;;;;;;;if Condition4 above = true, display "Person in the room" on the terminal
display_Cond4:
	jsr	print_newLine 
	LDD	#BAUD19K		;program SCI0's baud rate
	JSR	setbaud
	LDY	#cond4		;output "Person in the room"
	JSR	putStr_sc0
	;jsr 	print_strTerminate

	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;print_strTerminate:	
;		LDD	#BAUD19K		;program SCI0's baud rate
;		JSR	setbaud
;		LDY	#TerminateString 		;output the message
;		JSR	putStr_sc0
;		rts


;print_newLine:	LDD	#BAUD19K		;program SCI0's baud rate
;		JSR	setbaud
;		LDY	#newline		;output the message
;		JSR	putStr_sc0
;		rts





#include "DP256reg.asm"
#include "sci0api.asm"

		END



