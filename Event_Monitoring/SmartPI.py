
# coding: utf-8

# In[1]:


#OLIDemostorage_OLI5
# coding: utf-8

# In[63]:

import json
import time
import requests

from web3 import Web3, KeepAliveRPCProvider, IPCProvider, HTTPProvider


# In[2]:


# In[64]:

web3 = Web3(HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))

coinbase = web3.eth.coinbase
web3.eth.defaultBlock = "latest"
transaction = {'from': coinbase}


# In[3]:


# In[65]:

#define REST API
url1 = 'http://127.0.0.1:1080/api/1/power/now'
url2 = 'http://127.0.0.1:1080/api/2/power/now'
url3 = 'http://127.0.0.1:1080/api/3/power/now'

urls = [url1, url2, url3]


# In[4]:


# In[66]:

# define the adress, ABI (with parsing from str to JSON) and define the contract object
Olidaughter_address = '0x1fa0e615079dc94c1acf60fc8945fa29f8b07206'
Olidaughter_abi_str  = '[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint16"},{"name":"_rate","type":"uint8"}],"name":"bid","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setBilateralTrading","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliCoin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setDynamicGridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"resett","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_producer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_sRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_consumer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_dRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"maxRate","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"breakEven","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setParentAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"gaddr","type":"address"},{"indexed":false,"name":"grate","type":"uint8"},{"indexed":false,"name":"gamount","type":"uint16"}],"name":"NewGenBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"caddr","type":"address"},{"indexed":false,"name":"crate","type":"uint8"},{"indexed":false,"name":"camount","type":"uint16"}],"name":"NewConBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"cbid","type":"uint8"}],"name":"NewMcp","type":"event"}]'
Olidaughter_abi      = json.loads(Olidaughter_abi_str)
Olidaughter_contract = web3.eth.contract(abi=Olidaughter_abi,address=Olidaughter_address)


# In[5]:


# In[39]:
run = 1

while run == 1:
    total_power = 0
    for url in urls:
        r = requests.get(url)
        data = r.json()
        total_power_phase = data['datasets'][0]['phases'][0]['values'][0]['data']
        total_power = total_power + total_power_phase
        total_power = round(total_power)     


    print('---' + time.strftime('%d/%m/%Y %H:%M:%S') + '---')


    #wait for 2 minutes and print remaining time to window
    time.sleep(120)
    
    web3.personal.unlockAccount(coinbase, 'felix')

    olidemostorage_contract.transact(transaction).set_power(total_power)

    #wait for 5 minutes and print remaining time to window
    time.sleep(10)

