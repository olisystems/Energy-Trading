import paho.mqtt.publish as publish
import solar as s
import time

data1=s.realTimeData().solarVoltage()
data2=s.realTimeData().solarCurrent()
data3=s.realTimeData().batteryVoltage()
data4=s.realTimeData().batteryChargingCurrent()
data5=s.realTimeData().loadVoltage()
data6=s.realTimeData().loadCurrent()

host="host address"

while 1:
	 publish.single("OLI/solarSystem/solarVoltage",str(data1), hostname=host)
	 publish.single("OLI/solarSystem/solarCurrent",str(data2), hostname=host)
	 publish.single("OLI/solarSystem/batteryVoltage",str(data3), hostname=host)
	 publish.single("OLI/solarSystem/batteryChargingCurrent",str(data4), hostname=host)
	 publish.single("OLI/solarSystem/loadVoltage",str(data5), hostname=host)
	 publish.single("OLI/solarSystem/loadCurrent",str(data6), hostname=host)
	

	 print("Done")
	 time.sleep(5)
