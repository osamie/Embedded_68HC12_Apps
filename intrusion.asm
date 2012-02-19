;OSAZUWA OMIGIE


	ORG	$1000			;data area

message:	FCC	"The result is:"		; string: display message
Result:         DW  	0				; your result variable is this one; store the result here
Result_str	rmb	5

windows	db	%11111111

alarm	db	$80

keysPressed	dw	$4000 ;%1100000010000001 


cond1		fcc	"windows break - in"
TerminateString DB      0
cond2		fcc	"break-in"
tem_s	db 	0
cond3		fcc	"windows open"
tem_s2	db	0
cond4		fcc	"person in the room"
tem_s3	db	0
newline:	dw	$0A00


cont	rmb 10

		ORG	$4000			;program area

;;boolean intrusion (byte &windows, byte &alarm, int &keysPressed);
;;*delays are implemented using pushes and pulls


;;;;;;;;;;;;main function;;;;;;;;;;;;;;;;;
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;INTRUSION TEST 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jsr 	print_newLine   ;print a new line here
	
	
	;;;;;;;;now CALL "boolean intrusion (byte &windows, byte &alarm, int &keysPressed)";;;;;;;
	LDS	#$3DFF			;initialize stack pointer (details later)
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
	
	jsr 	print_newLine   ;print a new line here

;;;;;;;;;;;;;;;;;;;;;;;;;;END OF INTRUSION TEST 1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;DELAY BEFORE THE NEXT TEST
	

;;;;;;;;;;;;;;INTRUSION TEST 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	

	jsr 	print_newLine   ;print a new line here
	
	
	;;;;;;;;now CALL "boolean intrusion (byte &windows, byte &alarm, int &keysPressed)";;;;;;;
	;LDS	#$3DFF			;initialize stack pointer (details later)

	ldab    #$00		;load B with f0
	stab	windows		;;store content of B in variable windows

	ldab 	#$01		;load B with 01
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
	

;;;;;;;;;;;;;;;;;;;;;END OF TEST 2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;DELAY BY DOING PUSHES AND PULLING VALUES OF THE STACK BEFORE THE NEXT TEST
	
	
	



;;;;;;;;;;;;;;INTRUSION TEST 3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;END OF TEST 3;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	BRA *
	;pshy

;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
intrusion:
		

	pshd    ;;pushing first argument onto stack  
	pshx    ;;push base pointer
	tfr sp,x   ;;store the current position of the stack as my reference 
	
	leas -6,sp
	
	;movw 2,x -2,x
	;td -2,x
	
	jsr checkCond1    ;check for If the alarm is armed and the window is opened
	jsr checkCond2	  ;check if the alarm is armed and the "Infrared sensor" key is pressed	
	jsr checkCond3	  ;check if the alarm is off and the window is opened
	jsr checkCond4	  ;check if the alarm is off and the "Infrared sensor" key is pressed


		;LDD	#BAUD19K		;program SCI0's baud rate
		;JSR	setbaud

		;LDY	-2,x		;output the message
		;JSR	putStr_sc0

	
	
	tfr x,sp
	pulx
	leas 2,sp
	ldd #$3100
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
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#cond1		;output "windows"
	JSR	putStr_sc0		;takes a character in b and displays it
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


checkCond2b:  ;;;check if keysPressed[2nd MSB = 1]
	movw 8,x -2,x
	ldd [-2,x]
	anda #%01000000		;mask the next 7 bits to see the value of the MSB
	cmpa #%01000000		;compare the MSB to see if it is turned on
	beq display_Cond2	;if it is 1, that means infrared sensor key has been pressed thus display "Break in"
	rts	;return to checkCond2

;;;;;;;;;;;;;;if Condition = true, display "Break in" on the terminal
display_Cond2:
	jsr	print_newLine 
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
	LDY	#cond2		;output "Break in"
	JSR	putStr_sc0		;takes a character in b and displays it
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
;;alarm is off: alarm[MSB=0] && infrared sensor key pressed, keysPressed[2nd MSB=1]
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

checkCond4b:  ;;;check if keysPressed[2nd MSB = 1]
	movw 8,x -2,x
	ldaa [-2,x]
	anda #%01000000		;mask the other 7 bits to see the value of the second MSB
	cmpa #%01000000		;compare the 2nd MSB to see if it is turned on
	beq display_Cond4	;if it is 1, that means infrared sensor key has been pressed thus display "Person in the room"
	rts	;return to checkCond4

;;;;;;;;;;;;;;if Condition4 above = true, display "Person in the room" on the terminal
display_Cond4:
	jsr	print_newLine 
	LDD	#BAUD19K		;put program SCI0's baud rate in D
	JSR	setbaud			;;Sets up SCI0 with baud rate specified in register D
	LDY	#cond4		;output "Person in the room"
	JSR	putStr_sc0		;takes a character in b and displays it
	;jsr 	print_strTerminate

	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;



print_strTerminate:	
		LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#TerminateString 		;output the message
		JSR	putStr_sc0		;;takes a character in b and displays it
		rts


print_newLine:	LDD	#BAUD19K		;put program SCI0's baud rate in D
		JSR	setbaud			;Sets up SCI0 with baud rate specified in register D
		LDY	#newline		;output the message
		JSR	putStr_sc0		;takes a character in b and displays it
		rts





#include "DP256reg.asm"
#include "sci0api.asm"

		END