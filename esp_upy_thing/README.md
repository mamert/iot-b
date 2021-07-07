# esp-upy-thing
Because I could not come up with a better name.

Goal is to provide visual/aural feedback based on MPU readings.


raw values: approx. /128 for [-255, 255] range



	TODO: FFT & omega arithmetic? http://prosig.com/wp-content/uploads/pdf/blogArticles/OmegaArithmetic.pdf

	TODO WiFi control:
	* on/off
	* apply, separately store, sensitivity modifier
	* temporary override (keep at provided value while receiving it)




D1=5
D2=4
D4=2
D5=14
D6=12
D7 = 13
D8=15
D11=9 # can cause reset
D12=10 # sometimes input only

the old ESP board: 
LED0_PIN = D1
LED1_PIN = D2
SCL_PIN = D5
SDA_PIN = D6
BTN_PIN = D7
MPU_INT_PIN = D8
TO_TEST_0_PIN = D11
TO_TEST_1_PIN = D12


stacked D1 + charger + mpu:
SDA_PIN = D1
SCL_PIN = D2
WS_PIN = D4 # blue cable
LED0_PIN = D5
LED0B_PIN = D6
LED1_PIN = D7

D5, D6, D7 LEDs



help frozen bytecode:
frozen bytecode is vital for larger applications. In the esp8266 directory issue make clean. Then, in your source tree, copy the modules into ports/esp8266/modules. Compile and flash. Then at the REPL issue
>>> help('modules')
You should see your frozen modules listed



TODO:
* plastic insulation of inside part
* move electrodes inside
* check why taptic doesn't work (has volts? Unmelt)



