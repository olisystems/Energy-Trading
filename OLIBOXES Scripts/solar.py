from pymodbus.client.sync import ModbusSerialClient as ModbusClient
client = ModbusClient(method = 'rtu', port = '/dev/ttyAMA0', baudrate = 115200)
client.connect()




class realTimeData:
	def solarVoltage(self):
		sV=client.read_input_registers(0x3100,unit=1)
		solarVoltage =  float(sV.registers[0]/100.0)
		return solarVoltage
	def solarCurrent(self):
		sC=client.read_input_registers(0x3101,unit=1)
		solarCurrent =  float(sC.registers[0]/100.0)
		return solarCurrent
	def solarInputPower(self):
		sIPL=client.read_input_registers(0x3102,unit=1)
		solarInputPowerL= sIPL.registers[0]
		sIPH=client.read_input_registers(0x3103,unit=1)
		solarInputPowerH= sIPH.registers[0]
		solarInputPower=(solarInputPowerH<<16) | solarInputPowerL
		solarInputPower=(float)(solarInputPower/100.0)
		return solarInputPower
	def batteryVoltage(self):
		bV=client.read_input_registers(0x3104,unit=1)
		batteryVoltage= float(bV.registers[0]/100.0)
		return batteryVoltage
	def batteryChargingCurrent(self):
		bCC=client.read_input_registers(0x3105,unit=1)
		batteryChargingCurrent=float(bCC.registers[0]/100.0)
		return batteryChargingCurrent
	def batteryChargingPower(self):
		bCPL=client.read_input_registers(0x3106,unit=1)
		batteryChargingPowerL=bCPL.registers[0]
		bCPH=client.read_input_registers(0x3107,unit=1)
		batteryChargingPowerH=bCPH.registers[0]
		batteryChargingPower=(batteryChargingPowerH<<16) | batteryChargingPowerL
		batteryChargingPower=(float)(batteryChargingPower/100.0)
		return batteryChargingPower
	def loadVoltage(self):
        	lV=client.read_input_registers(0x310C,unit=1)
		loadVoltage=float(lV.registers[0]/100.0)
		return loadVoltage
	def loadCurrent(self):
        	lC=client.read_input_registers(0x310D,unit=1)
		loadCurrent=float(lC.registers[0]/100.0)
		return loadCurrent
	def loadPower(self):
        	lPL=client.read_input_registers(0x310E,unit=1)
		loadPowerL=lPL.registers[0]
       		lPH=client.read_input_registers(0x310F,unit=1)
		loadPowerH=lPH.registers[0]
		loadPower=(loadPowerH<<16)| loadPowerL
		loadPower=(float)(loadPower/100.0)
		return loadPower
	def batteryTemperature(self):
		bT=client.read_input_registers(0x3110, unit=1)
		batteryTemperature= float(bT.registers[0]/100.0)
		return batteryTemperature
	def caseTemperature(self):
		cT=client.read_input_registers(0x3111, unit=1)
		caseTemperature= float(cT.registers[0]/100.0)
		return caseTemperature
	def powerComponentTemperature(self):
		pCT=client.read_input_registers(0x3112, unit=1)
		powerComponentTemperature= float(pCT.registers[0]/100.0)
		return powerComponentTemperature
	def batteryRemainingCapacity(self):
		bRC=client.read_input_registers(0x311A, unit=1)
		batteryRemainingCapacity=float(bRC.registers[0]/100.0)
		return batteryRemainingCapacity
	def remotBatteryTemperature(self):
		rBT=client.read_input_registers(0x311B, unit=1)
		remoteBatteryTemperature= float(rBT.registers[0]/100.0)
		return remoteBatteryTemperature
	def batteryRatedVoltage(self):
		bRV=client.read_input_registers(0x311D, unit=1)
		batteryRatedVoltage= float(bRV.registers[0]/100.0)
		return batteryRatedVoltage


class realTimeStatus:
	def batteryStatus(self):
	 	bS=client.read_input_registers(0x3200, unit=1)
	 	batteryStatus=int(bS.registers[0])
		batteryStatus= "{0:<016b}".format(batteryStatus)
		return batteryStatus
	def chargingEqupmentStatus(self):
	 	cES=client.read_input_registers(0x3201, unit=1)
         	chargingEquipmentStatus=int(cES.registers[0])
		chargingEquipmentStatus= "{0:<016b}".format(chargingEquipmentStatus)
		return chargingEquipmentStatus

class statisticalParameter:
	def maxSolarVoltageToday(self):
	 	mSVTL=client.read_input_registers(0x3300, unit=1)
         	maxSolarVoltageTodayL=mSVTL.registers[0]
	 	mSVTH=client.read_input_registers(0x3301, unit=1)
         	maxSolarVoltageTodayH=mSVTH.registers[0]
	 	maxSolarVoltageToday=(maxSolarVoltageTodayH<<16) | maxSolarVoltageTodayL
		maxSolarVoltageToday=float(maxSolarVoltageToday/100.0)
		return maxSolarVoltageToday
	def maxBatteryVoltageToday(self):
	 	mBVTL=client.read_input_registers(0x3302, unit=1)
         	maxBatteryVoltageTodayL=mBVTL.registers[0]
	 	mBVTH=client.read_input_registers(0x3303, unit=1)
         	maxBatteryVoltageTodayH=mBVTH.registers[0]
	 	maxBatteryVoltageToday=(maxBatteryVoltageTodayH<<16) | maxBatteryVoltageTodayL
		maxBatteryVoltageToday=float(maxBatteryVoltageToday/100.0)
		return maxBatteryVoltageToday
	def consumedEnergyToday(self):
	 	cETL=client.read_input_registers(0x3304, unit=1)
         	consumedEnergyTodayL=cETL.registers[0]
		cETH=client.read_input_registers(0x3305, unit=1)
         	consumedEnergyTodayH=cETH.registers[0]
		consumedEnergyToday=(consumedEnergyTodayH<<16) | consumedEnergyTodayL
		consumedEnergyToday=float(consumedEnergyToday/100.0)
		return consumedEnergyToday
	def consumedEnergyMonth(self):
		cEML=client.read_input_registers(0x3306, unit=1)
         	consumedEnergyMonthL=cEML.registers[0]
         	cEMH=client.read_input_registers(0x3307, unit=1)
         	consumedEnergyMonthH=cEMH.registers[0]
		consumedEnergyMonth=(consumedEnergyMonthH<<16) | consumedEnergyMonthL
		consumedEnergyMonrh=float(consumedEnergyMonth/100.0)
		return consumedEnergyMonth
	def consumedEnergyYear(self):
	 	cEYL=client.read_input_registers(0x3308, unit=1)
         	consumedEnergyYearL=cEYL.registers[0]
         	cEYH=client.read_input_registers(0x3309, unit=1)
         	consumedEnergyYearH=cEYH.registers[0]
		consumedEnergyYear= (consumedEnergyYearH<<16) | consumedEnergyYearL
		consumedEnergyYear=float(consumedEnergyYear/100.0)
		return consumedEnergyYear
	def totalConsumedEnergy(self):
	 	tCEL=client.read_input_registers(0x330A, unit=1)
        	totalConsumedEnergyL=tCEL.registers[0]
         	tCEH=client.read_input_registers(0x330B, unit=1)
         	totalConsumedEnergyH=tCEH.registers[0]
		totalConsumedEnergy= (totalConsumedEnergyH<<16) | totalConsumedEnergyL
                totalConsumedEnergy=float(totalConsumedEnergy/100.0)
                return totalConsumedEnergy
	def generatedEnergyToday(self):
 	 	gETL=client.read_input_registers(0x330C, unit=1)
         	generatedEnergyTodayL=gETL.registers[0]
 	 	gETH=client.read_input_registers(0x330D, unit=1)
         	generatedEnergyTodayH=gETH.registers[0]
		generatedEnergyToday= (generatedEnergyTodayH<<16) | generatedEnergyTodayL
                generatedEnergyToday=float(generatedEnergyToday/100.0)
                return generatedEnergyToday
	def generatedEnergyMonth(self):
 	 	gEML=client.read_input_registers(0x330E, unit=1)
         	generatedEnergyMonthL=gEML.registers[0]
	 	gEMH=client.read_input_registers(0x330F, unit=1)
         	generatedEnergyMonthH=gEMH.registers[0]
		generatedEnergyMonth= (generatedEnergyMonthH<<16) | generatedEnergyMonthL
                generatedEnergyMonth=float(generatedEnergyMonth/100.0)
                return generatedEnergyMonth
	def generatedEnergyYear(self):
	 	gEYL=client.read_input_registers(0x3310, unit=1)
         	generatedEnergyYearL=gEYL.registers[0]
         	gEYH=client.read_input_registers(0x3311, unit=1)
         	generatedEnergyYearH=gEYH.registers[0]
		generatedEnergyYear= (generatedEnergyYearH<<16) | generatedEnergyYearL
                generatedEnergyYear=float(generatedEnergyYear/100.0)
                return generatedEnergyYear
	def totalGeneratedEnergy(self):
	 	tGEL=client.read_input_registers(0x3312, unit=1)
         	totalGeneratedEnergyL=tGEL.registers[0]
         	tGEH=client.read_input_registers(0x3313, unit=1)
         	totalGeneratedEnergyH=tGEH.registers[0]
		totalGeneratedEnergy= (totalGeneratedEnergyH<<16) | totalGeneratedEnergyL
                totalGeneratedEnergy=float(totalGeneratedEnergy/100.0)
                return totalGeneratedEnergy
	def carbonDioxideReduction(self):
	 	cDRL=client.read_input_registers(0x3314, unit=1)
        	carbonDioxideReductionL=cDRL.registers[0]
         	cDRH=client.read_input_registers(0x3315, unit=1)
         	carbonDioxideReductionH=cDRH.registers[0]
		carbonDioxideReduction=(carbonDioxideReductionH<<16) | carbonDioxideReductionL
		carbonDioxideReduction=float(carbonDioxideReduction/100.0)
		return carbonDioxideReduction
	def batteryCurrent(self):
	 	bCL=client.read_input_registers(0x331B, unit=1)
		batteryCurrentL=bCL.registers[0]
	 	bCH=client.read_input_registers(0x331C, unit=1)
         	batteryCurrentH=bCH.registers[0]
		batteryCurrent=(batteryCurrentH<<16) | batteryCurrentL
		batteryCurrent=float(batteryCurrent/100.0)
		return batteryCurrent
	def batteryTemperature(self):
 	 	bT=client.read_input_registers(0x331D, unit=1)
         	batteryTemperature=(float)(bT.registers[0]/100.0)
		return batteryTemperature
	def ambientTemperature(self):
         	aT=client.read_input_registers(0x331E, unit=1)
         	ambientTemperature=(float)(aT.registers[0]/100.0)
		return ambientTemperature

class settingParameter:
	def readBatteryType(self): 
		bT=client.read_holding_registers(0x9000, unit=1)
		batteryType= bT.registers[0]
		return batteryType
	def writeBatteryType(self,val):
                client.write_registers(0x9000,val, unit=1)
	def readBatteryCapacity(self): #Rated Capcity of the Battery
		bC=client.read_holding_registers(0x9001, unit=1)
		batteryCapacity=bC.registers[0]
		return batteryCapacity
 	def writeBatteryCapacity(self,val):
                client.write_registers(0x9001,val, unit=1)
	def readTemperatureCompensationCoefficient(self): #Range 0-9
                tCC=client.read_holding_registers(0x9002, unit=1)
                temperatureCompensationCoefficient=(float)(tCC.registers[0]/100.0)
                return temperatureCompensationCoefficient
        def writeTemperatureCompensationCoefficient(self,val): #Range(0-9)x100
                client.write_registers(0x9002,val, unit=1)
	def readHighVoltageDisconnect(self):
		hVD=client.read_holding_registers(0x9003, unit=1)
                highVoltageDisconnect=(float)(hVD.registers[0]/100.0)
                return highVoltageDisconnect
	def writeHighVoltageDisconnect(self,val):
		client.write_registers(0x9003,val, unit=1)
	def readChargingLimitVoltage(self):
		cLD=client.read_holding_registers(0x9004, unit=1)
                chargingLimitVoltage=(float)(cLD.registers[0]/100.0)
                return chargingLimitVoltage
	def writeChargingLimitVoltage(self,val):
                client.write_registers(0x9004,val, unit=1)
	def readOverVoltageReconnect(self):
                oVR=client.read_holding_registers(0x9005, unit=1)
                overVoltageReconnect=(float)(oVR.registers[0]/100.0)
                return overVoltageReconnect
        def writeOverVoltageReconnect(self,val):
                client.write_registers(0x9005,val, unit=1)
	def readEqualizationVoltage(self):
                eV=client.read_holding_registers(0x9006, unit=1)
                equalizationVoltage=(float)(eV.registers[0]/100.0)
                return equalizationVoltage
        def writeEqualizationVoltage(self,val):
                client.write_registers(0x9006,val, unit=1)
	def readBoostVoltage(self):
                bV=client.read_holding_registers(0x9007, unit=1)
                boostVoltage=(float)(bV.registers[0]/100.0)
                return boostVoltage
        def writeboostVoltage(self,val):
                client.write_registers(0x9007,val, unit=1)
	def readFloatVoltage(self):
                fV=client.read_holding_registers(0x9008, unit=1)
                floatVoltage=(float)(fV.registers[0]/100.0)
                return floatVoltage
        def writeFloatVoltage(self,val):
                client.write_registers(0x9008,val, unit=1)
	def readBoostReconnectVoltage(self):
                value=client.read_holding_registers(0x9009, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeBoostReconnectVoltage(self,val):
                client.write_registers(0x9009,val, unit=1)
	def readLowVoltageReconnect(self):
                value=client.read_holding_registers(0x900A, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeLowVoltageReconnect(self,val):
                client.write_registers(0x900A,val, unit=1)
	def readUnderVoltageRecover(self):
                value=client.read_holding_registers(0x900B, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeUnderVoltageRecover(self,val):
                client.write_registers(0x900B,val, unit=1)
	def readUnderVoltageWarning(self):
                value=client.read_holding_registers(0x900C, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeUnderVoltageWarning(self,val):
                client.write_registers(0x900C,val, unit=1)
	def readLowVoltageDisconnect(self):
                value=client.read_holding_registers(0x900D, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeLowVoltageDisconnect(self,val):
                client.write_registers(0x900D,val, unit=1)
	def readRealTimeClockSM(self):
                value=client.read_holding_registers(0x9013, unit=1)
                result=value.registers[0]
		min=(result>>8)
		sec=(result & 0xff)
                return {'sec':sec,'min':min,'result':result}
        def writeRealTimeClockSM(self,sec,min):
		val=(min<<8)|sec
                client.write_registers(0x9013,val, unit=1)
	def readRealTimeClockHD(self):
                value=client.read_holding_registers(0x9014, unit=1)
                result=value.registers[0]
                day=(result>>8)
                hour=(result & 0xff)
                return {'hour':hour,'day':day,'result':result}
        def writeRealTimeClockHD(self,hour,day):
                val=(day<<8)|hour
                client.write_registers(0x9014,val, unit=1)
	def readRealTimeClockMY(self):
                value=client.read_holding_registers(0x9015, unit=1)
                result=value.registers[0]
                year=(result>>8)
                month=(result & 0xff)
                return {'month':month,'year':year,'result':result}
        def writeRealTimeClockMY(self,month,year):
                val=(month<<8)|year
                client.write_registers(0x9015,val, unit=1)
	def readEqualizationChargingCycle(self):
		value=client.read_holding_registers(0x9016, unit=1)
                result=value.registers[0]
		return result
	def writeEqualizationChargingCycle(self,val):
                client.write_registers(0x9016,val, unit=1)
	def readBatteryTempUpperLimit(self):
                value=client.read_holding_registers(0x9017, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeBatteryTempUpperLimit(self,val):
                client.write_registers(0x9017,val, unit=1)
	def readBatteryTempLowerLimit(self):
                value=client.read_holding_registers(0x9018, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeBatteryTempLowerLimit(self,val):
                client.write_registers(0x9018,val, unit=1)
	def readControllerTempUpperLimit(self):
                value=client.read_holding_registers(0x9019, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeControllerTempUpperLimit(self,val):
                client.write_registers(0x9019,val, unit=1)
	def readControllerTempUpperLimitRecover(self):
                value=client.read_holding_registers(0x901A, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeControllerTempUpperLimitRecover(self,val):
                client.write_registers(0x901A,val, unit=1)
	def readPowerComponentTempUpperLimit(self):
                value=client.read_holding_registers(0x901B, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writePowerComponentTempUpperLimit(self,val):
                client.write_registers(0x901B,val, unit=1)
	def readPowerComponentTempUpperLimitRecover(self):
                value=client.read_holding_registers(0x901C, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writePowerComponentTempUpperLimitRecover(self,val):
                client.write_registers(0x901C,val, unit=1)
	def readLineImpedence(self):
                value=client.read_holding_registers(0x901D, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeLineImpedence(self,val):
                client.write_registers(0x901D,val, unit=1)
	def readNightTimeThresholdVolt(self):
                value=client.read_holding_registers(0x901E, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeNightTimeThresholdVolt(self,val):
                client.write_registers(0x901E,val, unit=1)
	def readLightSignalStartupDelayTime(self):
                value=client.read_holding_registers(0x901F, unit=1)
                result=value.registers[0]
                return result
        def writeNightSignalStartupDelayTime(self,val):
                client.write_registers(0x901F,val, unit=1)
	def readDayTimeThresholdVolt(self):
                value=client.read_holding_registers(0x9020, unit=1)
                result=(float)(value.registers[0]/100.0)
                return result
        def writeDayTimeThresholdVolt(self,val):
                client.write_registers(0x9020,val, unit=1)
	def readLightSignalTurnOffDelayTime(self):
		value=client.read_holding_registers(0x9021, unit=1)
                result=value.registers[0]
                return result
	def writeLightSignalTurnOffDelayTime(self,val):
                client.write_registers(0x9021,val, unit=1)
	def readLoadControllingModes(self):
		value=client.read_holding_registers(0x903D, unit=1)
                result=value.registers[0]
                return result
	def writeLoadControllingModes(self,val):
                client.write_registers(0x903D,val, unit=1)
	def readWorkingTimeLengthTimer1(self):
                value=client.read_holding_registers(0x903E, unit=1)
                result=value.registers[0]
                return result
        def writeWorkingTimeLengthTimer1(self,val):
                client.write_registers(0x903E,val, unit=1)
	def readWorkingTimeLengthTimer2(self):
                value=client.read_holding_registers(0x903F, unit=1)
                result=value.registers[0]
                return result
        def writeWorkingTimeLengthTimer2(self,val):
                client.write_registers(0x903F,val, unit=1)
	def readTurnOnTimingS1(self):
                value=client.read_holding_registers(0x9042, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingS1(self,val):
                client.write_registers(0x9042,val, unit=1)
	def readTurnOnTimingM1(self):
                value=client.read_holding_registers(0x9043, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingM1(self,val):
                client.write_registers(0x9043,val, unit=1)
	def readTurnOnTimingH1(self):
                value=client.read_holding_registers(0x9044, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingH1(self,val):
                client.write_registers(0x9044,val, unit=1)
	def readTurnOffTimingS1(self):
                value=client.read_holding_registers(0x9045, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingS1(self,val):
                client.write_registers(0x9045,val, unit=1)
        def readTurnOffTimingM1(self):
                value=client.read_holding_registers(0x9046, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingM1(self,val):
                client.write_registers(0x9046,val, unit=1)
        def readTurnOffTimingH1(self):
                value=client.read_holding_registers(0x9047, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingH1(self,val):
                client.write_registers(0x9047,val, unit=1)
	def readTurnOnTimingS2(self):
                value=client.read_holding_registers(0x9048, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingS2(self,val):
                client.write_registers(0x9048,val, unit=1)
        def readTurnOnTimingM2(self):
                value=client.read_holding_registers(0x9049, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingM2(self,val):
                client.write_registers(0x9049,val, unit=1)
        def readTurnOnTimingH2(self):
                value=client.read_holding_registers(0x904A, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOnTimingH2(self,val):
                client.write_registers(0x904A,val, unit=1)
	def readTurnOffTimingS2(self):
                value=client.read_holding_registers(0x904B, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingS2(self,val):
                client.write_registers(0x904B,val, unit=1)
        def readTurnOffTimingM2(self):
                value=client.read_holding_registers(0x904C, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingM2(self,val):
                client.write_registers(0x904C,val, unit=1)
        def readTurnOffTimingH2(self):
                value=client.read_holding_registers(0x904D, unit=1)
                result=value.registers[0]
                return result
        def writeTurnOffTimingH2(self,val):
                client.write_registers(0x904D,val, unit=1)
	def readLengthOfNight(self):
                value=client.read_holding_registers(0x9065, unit=1)
                result=value.registers[0]
                hour=(result>>8)
                min=(result & 0xff)
                return {'min':min,'hour':hour,'result':result}
        def writeRealTimeClockSM(self,min,hour):
                val=(hour<<8)|min
                client.write_registers(0x9013,val, unit=1)
	def readBatteryRatedVoltageCode(self):
                value=client.read_holding_registers(0x9067, unit=1)
                result=value.registers[0]
                return result
        def writeBatteryRatedVoltageCode(self,val):
                client.write_registers(0x9067,val, unit=1)
	def readLoadTimingControlSelection(self):
                value=client.read_holding_registers(0x9069, unit=1)
                result=value.registers[0]
                return result
        def writeLoadTimingControlSelection(self,val):
                client.write_registers(0x9069,val, unit=1)
	def readDefaultOnOffManualMode(self):
                value=client.read_holding_registers(0x906A, unit=1)
                result=value.registers[0]
                return result
        def writeDefaultOnOffManualMode(self,val):
                client.write_registers(0x906A,val, unit=1)
	def readEqualizeDuration(self):
                value=client.read_holding_registers(0x906B, unit=1)
                result=value.registers[0]
                return result
        def writeEqualizeDuration(self,val):
                client.write_registers(0x906B,val, unit=1)
	def readBoostDuration(self):
                value=client.read_holding_registers(0x906C, unit=1)
                result=value.registers[0]
                return result
        def writeBoostDuration(self,val):
                client.write_registers(0x906C,val, unit=1)
	def readDischargingPercentage(self):
                value=client.read_holding_registers(0x906D, unit=1)
                result=value.registers[0]
                return result
        def writeDischargingPercentage(self,val):
                client.write_registers(0x906D,val, unit=1)
	def readChargingPercentage(self):
                value=client.read_holding_registers(0x906E, unit=1)
                result=value.registers[0]
                return result
        def writeChargingPercentage(self,val):
                client.write_registers(0x906E,val, unit=1)
	def readManagementModeBatteryChargeDischarge(self):
                value=client.read_holding_registers(0x9070, unit=1)
                result=value.registers[0]
                return result
        def writeManagementModeBatteryChargeDischarge(self,val):
                client.write_registers(0x9070,val, unit=1)
class coil:
	def readManualControlLoad(self):
		value=client.read_coils(2,1,unit=1)
		return value.bits
	def writeManualControlLoad(self,val):
		client.write_coil(2,val,unit=1)
	def readEnableLoadTestMode(self):
                value=client.read_coils(5,1,unit=1)
                return value.bits
        def writeEnableLoadTestMode(self,val):
                client.write_coil(5,val,unit=1)
	def readForceLoadOnOff(self):
                value=client.read_coils(6,1,unit=1)
                return value.bits
        def writeForceLoadOnOff(self,val):
                client.write_coil(6,val,unit=1)
class discreteInput:
	def OverTempInsideDevice(self):
		value=client.read_input_registers(0x2000,1,unit=1)
		result=value.registers[0]
		return result
	def DayNight(self):
		value=client.read_input_registers(0x200C,1,unit=1)
                result=value.registers[0]
                return result

print realTimeData().loadPower()
print statisticalParameter().ambientTemperature()
print realTimeStatus().batteryStatus()
print settingParameter().readRealTimeClockSM().get('sec')
print settingParameter().readRealTimeClockSM().get('min')
print settingParameter().readRealTimeClockSM().get('result')


client.close()
