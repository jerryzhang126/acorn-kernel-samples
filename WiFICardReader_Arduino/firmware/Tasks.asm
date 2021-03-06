;*****DON'T PUT INCLUDE FILES BEFORE TASK 1 DEFINITION

;connection status
#define ESP8266_CONNECTED_TO_AP 1
#define	ESP8266_CREATED_TRANSMISSION 2
#define	ESP8266_TRANSMISSION_DISCONNECTED 3
#define	ESP8266_NOT_CONNECTED_TO_AP 4
#define	ESP8266_CONNECT_UNKNOWN_ERROR 5

;response status
#define	ESP8266_RESPONSE_WAITING 1
#define	ESP8266_RESPONSE_FINISHED 2
#define	ESP8266_RESPONSE_TIMEOUT 3
#define	ESP8266_RESPONSE_BUFFER_FULL 4
#define	ESP8266_RESPONSE_STARTING 5
#define	ESP8266_RESPONSE_ERROR 6

#define DEFAULT_TIMEOUT   9*10 ;100ms resolution seconds



#define LCD_UPDATE_EVENT 0
#define DATA_READY_EVENT 1
#define WIEGAND_READY_EVENT 2
#define NORMAL_MODE_EVENT 3
#define WIFI_RESULT_EVENT 4

.set EEPROM_CONFIG_ADDR = 0x0000 

.set EEPROM_MAX_BUFFER_SIZE=100

.set WRITE_EEPROM=0x55
.set READ_EEPROM=0xAA


.def    argument=r17  
.def    return = r18
.def    axl=r19
.def    axh=r20

.def	bxl=r21
.def    bxh=r22

System_Task:
 //***turn off Watch dog reset for testing purpous
 cli
; Reset Watchdog Timer
 wdr
 ; Clear WDRF in MCUSR
 in temp, MCUSR
 andi temp, (0xff & (0<<WDRF))
 out MCUSR, temp
 ; Write '1' to WDCE and WDE
 ; Keep old prescaler setting to prevent unintentional time-out
 lds temp, WDTCSR
 ori temp, (1<<WDCE) | (1<<WDE)
 sts WDTCSR, temp
 ; Turn off WDT
 ldi temp, (0<<WDE)
 sts WDTCSR, temp
 ; Turn on global interrupt
 sei

_THRESHOLD_BARRIER_WAIT InitTasksBarrier,TASKS_NUMBER 



main1:

nop
_YIELD_TASK 

rjmp main1  


.include "include/configtask.asm"

.include "include/lcdtask.asm"

.include "include/cardtask.asm"

.include "include/wifitask.asm"

.include "include/alarmtask.asm"


.EXIT









