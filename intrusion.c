/**
 AUTHOR: OSAZUWA OMIGIE
 
 Description:
 
 -Testing in Main
	windows, temperature, alarm. and infrared sensor: simulated with hard coded bits.
	Values will be received via I/O interfaces
 
 -boolean intrusion (byte *windows, byte *alarm, int *keysPressed);
  // parameter windows contains the current status of the windows: the LSB = 1 means 
  // the windows are open; the MSB = 1 means the blinds are open. temperature  
  // contains the temperature system status: the second MSB = 1 means the fan is on; the  
  // second LSB = 1 means the heater is on. alarm contains the current alarm status.  
  // The MSB = 1 means the alarm is armed. keysPressed contains information about 
 // the keys pressed by the user (16 keys = 16 bits; when a key is pressed, a bit is on).
 
**/

#include <stdio.h>
#include <stdlib.h>

#define False 0		//macro: anywhere we use the keyword False, it represents '0' 
#define True !False //macro: anywhere we use the keyword True, it represents anything that is not 0 or False 

typedef unsigned char byte; //In this file, I will be representing bytes as unsigned characters. Bytes used in the context of this file are always addresses which are never NEGATIVE

typedef unsigned char boolean; //boolean or bool will be represented as integers.


//declare our function here. (During compile time, space is reserved for the function)
boolean intrusion (byte *windows, byte *alarm, int *keysPressed);



/** 
	This function reports (on the terminal) an alarm condition, as follows:  
. If the alarm is armed and the window is opened, it displays “windows break-in”. 
. If the alarm is armed and the “Infrared sensor” key is pressed (second MSB of 
keysPressed is set), it displays “break-in”  
. If the alarm is off and the window is opened, it displays “windows open”. 
. If the alarm is off and the “Infrared sensor” key is pressed (second MSB of 
keysPressed is set), it displays “person in the room”  **/

boolean intrusion (byte *windows, byte *alarm, int *keysPressed){
		
		byte windows_l = *windows;  //we create a copy of windows so that our manipulation does not change the variable being pointed to outside the function 
		byte alarm_l = *alarm; //we create a copy of alarm so that our manipulation does not change the variable being pointed to outside the function
		int KeysPressed_l = *keysPressed; //we create a copy of keysPressed so that our manipulation does not change the variable being pointed to outside the function
		
		boolean result = 0,success1=0,success2=0,success3=0,success4 = 0;  //initialize our result values 
	
		
		
		//The condition variables below are initialised with false;  
		boolean alarm_armed = False, infrared_sensor_key = False, windows_open = False ;
		
		//Below we re-assign the condition variables based on the values of our parameters 
		alarm_l = alarm_l & 0x80; //masking: turn off all other bits leaving only the MSB on
		
		if(alarm_l == 0x80 ) //check if the alarm is armed
		{
		 	alarm_armed = True;	   		//set alarm_armed to true
		}
		
		windows_l = windows_l & 0x01; //masking: turn off all other bits leaving only the LSB on
		if(windows_l == 0x01)//check if the window is opened 
		{
		   windows_open = True;
		}
		
		KeysPressed_l = KeysPressed_l & 0x4000; //masking: turn off all other bits leaving only the MSB on
		if(KeysPressed_l == 0x4000) //check if the most significant bit is set
		{
		 	infrared_sensor_key = True; 
		}
		
		
		//If the alarm is armed and the window is opened, it displays “windows break-in” 
						
		if(alarm_armed && windows_open ) //check if the alarm is armed
		{		
				success1 = printf("windows break-in \n");   
		   
		}
		
		//If the alarm is armed and the “Infrared sensor” key is pressed (second MSB of keysPressed is set), display “break-in”
		if (alarm_armed && infrared_sensor_key )
		{
		   success2 = printf("break-in \n");
		}
		
		//If the alarm is off and the window is opened, it displays “windows open”
		if((alarm_armed == False) && windows_open )
		{
		 	success3 = printf("windows open \n");
		}
		
		//If the alarm is off and the “Infrared sensor” key is pressed (second MSB of keysPressed is set), it displays “person in the room”
		if((alarm_armed == False) && infrared_sensor_key )
		{
		 	success4 = printf("person in the room \n");
		}
						
		
		return (success1 && success2 && success3 && success4); //value returned will be the boolean result from a logical and of the results of the 4 printf() calls
}

int main (void){
	//typedef unsigned char byte;
	
	//
	byte windows = 0xff;  //windows open 
	byte alarm = 0x3f;    //alarm off
	int keysPressed = 0x1201;   //infrared sensor key not pressed 
	
	printf("OSAZUWA OMIGIE \n");
	printf("-------TEST 1----------\n");
	printf("test values:\n windows: 0x%x \n Alarm: 0x%x \n keysPressed: 0x%x \n",windows, alarm, keysPressed);
	intrusion(&windows, &alarm, &keysPressed); //call the intrusion function
	
	
	windows = 0x00; 
	alarm = 0x81;
	keysPressed =0x4309;  //infrared sensor key not pressed
	printf("\n \n -------TEST 2----------\n");
	printf("test values:\n windows: 0x%x \n Alarm: 0x%x \n keysPressed: 0x%x \n",windows, alarm, keysPressed);
	intrusion(&windows, &alarm, &keysPressed); //call the intrusion function
	
	
	windows = 0x00; 
	alarm = 0x00;
	keysPressed = 0x4008; 
	printf("\n \n-------TEST 3----------\n");
	printf("test values:\n windows: 0x%x \n Alarm: 0x%x \n keysPressed: 0x%x \n",windows, alarm, keysPressed);
	intrusion(&windows, &alarm, &keysPressed); //call the intrusion function

	return 0;
	
}