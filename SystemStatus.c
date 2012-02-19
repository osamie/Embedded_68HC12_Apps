/*
 AUTHOR: OSAZUWA OMIGIE
 
 Description: 
 
 -Testing in Main
	windows, temperature, alarm. and infrared sensor: simulated with hard coded bits.
 
-bool displaySystemStatus (byte *windows, byte *temperature, byte *alarm, int *keysPressed);  
 // parameter windows contains the current status of the windows: the LSB = 1 means 
 // the windows are open; the MSB = 1 means the blinds are open. temperature  
 // contains the temperature system status: the second MSB = 1 means the fan is on; the  
 // second LSB = 1 means the heater is on. alarm contains the current alarm status.  
 // The MSB = 1 means the alarm is armed. keysPressed contains information about 
 // the keys pressed by the user (16 keys = 16 bits; when a key is pressed, a bit is on).
 
*/

#include <stdio.h>
#include <stdlib.h>

#define False 0		//macro: anywhere we use the keyword False, it represents '0' 
#define True !False //macro: anywhere we use the keyword True, it represents anything that is not 0 or False 

typedef unsigned char byte;   //In this file, I will be representing bytes as unsigned characters. Bytes used in the context of this file are always addresses which are never NEGATIVE

typedef int bool, boolean;  //boolean or bool will be represented as integers.


//declare our function here. (During compile time, space is reserved for the function)
bool displaySystemStatus (byte *windows, byte *temperature, byte *alarm, int *keysPressed);  


/**
 This function receives the address of windows, temperature, alarm, and keys pressed.
 - Displays their values in hexadecimal,
 - Returns a boolean value that indicates success/error of the function
 **/
bool displaySystemStatus (byte *windows, byte *temperature, byte *alarm, int *keysPressed)
{
 	 bool result = False;   //By default our return value will be false 
	
	/**
	 printf() function resturns 1 when successful or 0 when an error is encountered
	 **/
	
	//now we store the results of each print requests in separate variables, so we can compare them.
 	 int success1 = printf("\n windows: %x \n",*windows);   
	 int success2 = printf(" temperature: %x \n",*temperature );
	 int success3 = printf(" alarm: %x \n", *alarm);
	 int success4 = printf(" keysPressed: %x \n", *keysPressed);
	 
	//if all 4 printf() functions above were successful, then return our result as true.   
	//else return False (our default value for result)
	if(success1 > 0 && success2 > 0 && success3>0 && success4>0)
	 {
	  	result = True;
	 }
	
	 
	 return result;

}



int main(void){
	
	//TEST 1:
	printf("\n ---------------TEST 1----------------------");
	byte windows = 0x20;  //windows closed
	byte temperature = 0x1f;  
	byte alarm = 0x80;  //alarm armed
	int keysPressed = 0x4122;  //infrared sensor key pressed
	
	
	int result = displaySystemStatus (&windows, &temperature, &alarm, &keysPressed);
	//the int value returned from displaySystemStatus() function indicated success/error (1/0)
	
	if (result == 0)  
	{
	   printf("The result was ERROR \n");  //print result on the terminal
	} 
	else{
		 printf("The result was SUCESSFUL \n");  //print result on the terminal
	}
	
	
	
	//TEST 2
	printf("\n ---------------TEST 2----------------------");
	windows = 0x11;   //windows open
	temperature = 0x42;  
	alarm = 0xff;
	keysPressed = 0xf121;   //infrared sensor key is not pressed
	
	result = displaySystemStatus (&windows, &temperature, &alarm, &keysPressed);
	//UNSUCESSFUL!
	if (result == 0)
	{
		printf("The result was UNSUCESSFUL \n");
	} 
	else{
		printf("The result was SUCESSFUL \n");
	}
	
	
	//TEST 3
	printf("\n ---------------TEST 3----------------------");
	windows = 0x80;   //windows closed
	temperature = 0x48;  
	alarm = 0x1f;	//alarm unarmed
	keysPressed = 0xf181;  //infrared sensor key is pressed
	
	result = displaySystemStatus (&windows, &temperature, &alarm, &keysPressed);
	//UNSUCESSFUL!
	if (result == 0)
	{
		printf("The result was UNSUCESSFUL \n");
	} 
	else{
		printf("The result was SUCESSFUL \n");
	}
		
	return 0;
}
