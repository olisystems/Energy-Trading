import paho.mqtt.client as mqtt
from threading import Timer
import time
import json
from web3 import Web3, KeepAliveRPCProvider, IPCProvider, HTTPProvider

def timeout():
	web3 = Web3(HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))
	coinbase = web3.eth.coinbase
	web3.personal.unlockAccount(coinbase,'felixhassan')
	print("in timeout")
def web3_block(data):
	web3 = Web3(HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))
	coinbase = web3.eth.coinbase
	web3.eth.defaultBlock = "latest"
	transaction = {'from': coinbase}
	# In[3]:
	# define the adress, ABI (with parsing from str to JSON) and define the contract object
	olidemostorage_address = '0xac84e242224d63933f49c12eb937b4c3a9c3b956'
	olidemostorage_abi_str  = '[{"constant":true,"inputs":[],"name":"get_voltage","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"y","type":"uint256"}],"name":"set_voltage","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get_power","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set_power","outputs":[],"payable":false,"type":"function"}]'
	olidemostorage_abi      = json.loads(olidemostorage_abi_str)
	olidemostorage_contract = web3.eth.contract(abi=olidemostorage_abi,address=olidemostorage_address)
	# In[4]:
	olidemostorage_contract
	# In[5]:

	# unlock account + send transaction to the olidemostorage_contract to the set_power function with the corresponding value
	#web3.personal.unlockAccount(coinbase, 'felixhassan')
#	def timeout():
#        	web3.personal.unlockAccount(coinbase,'felixhassan')

#	t= Timer(4*60, timeout)
#	t.start()
	olidemostorage_contract.transact(transaction).set_power(data)
	# In[6]:

	#Get the power value through a "Call" from the smart contract on the local hard drive
	a=olidemostorage_contract.call().get_power()
	print(a)


def on_connect(client,userdata, flags, rc):
	if rc==0:
		print("Connection Successful")
		client.subscribe("OLI/solarSystem/solarVoltage")
		client.subscribe("OLI/solarSystem/solarPower")
		client.subscribe("OLI/solarSystem/solarCurrent")
		client.subscribe("OLI/solarSystem/remoteBatteryTemperature")
		client.subscribe("OLI/solarSystem/batteryVoltage")
		client.subscribe("OLI/solarSystem/batteryChargingCurrent")
		client.subscribe("OLI/solarSystem/loadVoltage")
		client.subscribe("OLI/solarSystem/loadCurrent")
	
	else:
		print("Bad connection code=",rc)
def on_message(client,userdata,message):
	print(message.topic+" "+str(message.payload))
	a=str(message.payload)
	a=a.replace("b","")
	a=a.replace("'","")
	a=float(a)
	a=int(a*1000)
	#print (a)
#	timeout()
	try:
		web3_block(a)
	except ValueError:
		timeout()
		web3_block(a)
broker="192.168.0.23"
client = mqtt.Client("OLI_Main")
client.on_connect=on_connect
client.on_message=on_message

print("Connecting to broker ", broker)
client.connect(broker)
time.sleep(1)

print("In Main Loop")
client.loop_forever()
client.disconnect()


