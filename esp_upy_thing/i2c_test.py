import machine

SCL_PIN = 5  # GPIO 5 is D1
SDA_PIN = 4  # GPIO 4 is D2

i2c = machine.I2C(scl=machine.Pin(SCL_PIN), sda=machine.Pin(SDA_PIN))
 
print('Scan i2c bus...')
devices = i2c.scan()
 
if len(devices) == 0:
  print("No i2c device !")
else:
  print('i2c devices found:',len(devices))
 
  for device in devices:  
    print("Decimal address: ",device," | Hex address: ",hex(device))