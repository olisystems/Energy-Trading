
# coding: utf-8

# In[1]:


# coding: utf-8

import json
import web3
import math
import random
import time

from web3 import Web3, IPCProvider, HTTPProvider


# In[2]:


web3 = Web3(HTTPProvider("http://127.0.0.1:8545", request_kwargs={'timeout': 600}))
coinbase = web3.eth.coinbase
web3.eth.defaultBlock = "latest"
transaction = {'from': coinbase}


# In[3]:


# define the adress, ABI (with parsing from str to JSON) and define the contract object
Oliorigin_address = web3.toChecksumAddress(0x3a9c865ff25ddaa0901dd6abe68b92f7a6b151fe)
Oliorigin_abi_str  = '[{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliType","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliCkt","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliTrafoid","outputs":[{"name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tid","type":"uint32"}],"name":"get_gsoAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"},{"name":"_index","type":"uint8"}],"name":"get_oliPeakLoad","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"oli","type":"address"},{"name":"lat","type":"uint32"},{"name":"long","type":"uint32"},{"name":"trafo","type":"uint32"},{"name":"ckt","type":"uint8"},{"name":"typex","type":"uint8"},{"name":"pload","type":"uint16[]"}],"name":"addOli","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"paymentAddress","type":"address"},{"indexed":false,"name":"latOfLocation","type":"uint32"},{"indexed":false,"name":"longOfLocation","type":"uint32"}],"name":"newAddedOli","type":"event"}]'
Oliorigin_abi      = json.loads(Oliorigin_abi_str)
Oliorigin_contract = web3.eth.contract(abi=Oliorigin_abi,address=Oliorigin_address)


# In[4]:


# define the adress, ABI (with parsing from str to JSON) and define the contract object
Olicoin_address = web3.toChecksumAddress(0xdb0f919b72c20948e6c6c06c1280c7aed3a48b51)
Olicoin_abi_str  = '[{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"caddress","type":"address"}],"name":"get_coinBalance","outputs":[{"name":"","type":"int32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_contract","type":"address"},{"name":"_tf","type":"bool"}],"name":"set_ContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_change","type":"int32"}],"name":"set_OliCoinBalance","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint16"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint16"}],"name":"Transfer","type":"event"}]'
Olicoin_abi      = json.loads(Olicoin_abi_str)
Olicoin_contract = web3.eth.contract(abi=Olicoin_abi,address=Olicoin_address)


# In[5]:


# define the adress, ABI (with parsing from str to JSON) and define the contract object
Olibilateral_address = web3.toChecksumAddress(0x1304209854905c947f2ce1140eac577301c1baee)
Olibilateral_abi_str  = '[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_stock","type":"address"},{"name":"_rate","type":"uint8"}],"name":"stockBidding","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockAmount","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint16"},{"name":"_rate","type":"uint8"},{"name":"_period","type":"uint32"},{"name":"_btime","type":"uint32"}],"name":"regStock","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockBidder","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockRate","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"saccount","type":"address"},{"indexed":false,"name":"samount","type":"uint16"},{"indexed":false,"name":"smrate","type":"uint8"},{"indexed":false,"name":"speriod","type":"uint32"},{"indexed":false,"name":"sbiddingTime","type":"uint32"}],"name":"NewStock","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"baccount","type":"address"},{"indexed":false,"name":"bmrate","type":"uint8"}],"name":"NewStockBid","type":"event"}]'
Olibilateral_abi      = json.loads(Olibilateral_abi_str)
Olibilateral_contract = web3.eth.contract(abi=Olibilateral_abi,address=Olibilateral_address)


# In[6]:


# define the adress, ABI (with parsing from str to JSON) and define the contract object
Olidaughter_address = web3.toChecksumAddress(0xced60ac716aabcc6ee9aff2d0982cb5e29371d51)
Olidaughter_abi_str  = '[{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint16"},{"name":"_rate","type":"uint8"}],"name":"bid","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setBilateralTrading","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliCoin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setDynamicGridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"resett","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_producer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_sRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_consumer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_dRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"maxRate","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"breakEven","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"gaddr","type":"address"},{"indexed":false,"name":"grate","type":"uint8"},{"indexed":false,"name":"gamount","type":"uint16"}],"name":"NewGenBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"caddr","type":"address"},{"indexed":false,"name":"crate","type":"uint8"},{"indexed":false,"name":"camount","type":"uint16"}],"name":"NewConBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"cbid","type":"uint8"}],"name":"NewMcp","type":"event"}]'
Olidaughter_abi      = json.loads(Olidaughter_abi_str)
Olidaughter_contract = web3.eth.contract(abi=Olidaughter_abi,address=Olidaughter_address)


# In[7]:


# define the adress, ABI (with parsing from str to JSON) and define the contract object
DynamicGridFee_address = web3.toChecksumAddress(0x46bfeab0556ac1ae91c60f302d146712b9df50b4)
DynamicGridFee_abi_str  = '[{"constant":true,"inputs":[{"name":"_tid","type":"uint32"},{"name":"_index","type":"uint8"}],"name":"get_gridFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_trafocamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_cktcamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tid","type":"uint32"}],"name":"set_tgridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tid","type":"uint32"},{"name":"_index","type":"uint8"}],"name":"get_cktAmount","outputs":[{"name":"","type":"int16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_tGFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"},{"name":"_fee","type":"uint8[]"}],"name":"set_minmaxgfee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_traforamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_dGFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tid","type":"uint32"}],"name":"set_dgridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint64"}],"name":"set_cktramount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_trafoAmount","outputs":[{"name":"","type":"int16"}],"payable":false,"stateMutability":"view","type":"function"}]'
DynamicGridFee_abi      = json.loads(DynamicGridFee_abi_str)
DynamicGridFee_contract = web3.eth.contract(abi=DynamicGridFee_abi,address=DynamicGridFee_address)


# In[8]:


account_0=web3.eth.accounts[0]
account_1=web3.eth.accounts[1]
account_2=web3.eth.accounts[2]
account_3=web3.eth.accounts[3]
account_4=web3.eth.accounts[4]
account_5=web3.eth.accounts[5]
account_6=web3.eth.accounts[6]
account_7=web3.eth.accounts[7]
account_8=web3.eth.accounts[8]
account_9=web3.eth.accounts[9]
account_10=web3.eth.accounts[10]
account_11=web3.eth.accounts[11]
account_12=web3.eth.accounts[12]
account_13=web3.eth.accounts[13]
account_14=web3.eth.accounts[14]
account_15=web3.eth.accounts[15]
account_16=web3.eth.accounts[16]
account_17=web3.eth.accounts[17]
account_18=web3.eth.accounts[18]
account_19=web3.eth.accounts[19]
account_20=web3.eth.accounts[20]
account_21=web3.eth.accounts[21]
account_22=web3.eth.accounts[22]


# In[ ]:


#Register OLIs - Only Once!!

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_1, int(49.30e4), int(8.35e4), 67376, 0, 0, [6000])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_2, int(48.39e4), int(9.97e4), 67376, 1, 3, [5500])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_3, int(48.77e4), int(9.16e4), 67376, 0, 5, [4000])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_4, int(49.40e4), int(8.67e4), 67376, 1, 0, [10000])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_5, int(48.89e4), int(9.20e4), 67376, 0, 5, [7800])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_6, int(48.62e4), int(9.83e4), 67376, 0, 6, [4600])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_7, int(48.00e4), int(7.84e4), 67376, 1, 6, [7600])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_8, int(49.49e4), int(8.47e4), 67376, 0, 7, [3800])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_9, int(49.32e4), int(8.44e4), 67376, 1, 7, [5400])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_10, int(48.41e4), int(10.00e4), 67376, 0, 7, [7800])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_11, int(48.69e4), int(9.21e4), 67377, 0, 0, [9000])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_12, int(49.47e4), int(8.47e4), 67377, 1, 3, [4500])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_13, int(48.42e4), int(10.07e4), 67377, 0, 5, [3600])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_14, int(48.80e4), int(9.22e4), 67377, 1, 0, [6000])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_15, int(48.87e4), int(9.22e4), 67377, 0, 5, [4900])

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_16, int(48.87e4), int(9.19e4), 67377, 0, 6, [6600])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_17, int(48.81e4), int(9.18e4), 67377, 1, 6, [8000])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_18, int(48.40e4), int(9.96e4), 67377, 0, 7, [12000])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_19, int(48.50e4), int(10.06e4), 67377, 1, 7, [4000])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_20, int(48.60e4), int(10.16e4), 67377, 0, 7, [7500])


# In[ ]:


#Register Trafos

web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_21, int(49.30e4), int(8.35e4), 67376, 2, 8, [1000, 750, 750])
web3.personal.unlockAccount(coinbase, 'olirocks')
Oliorigin_contract.transact({'from': coinbase}).addOli(account_22, int(48.69e4), int(9.21e4), 67377, 2, 8, [1000, 750, 750])


# In[ ]:


#Register Contract address for coin update
web3.personal.unlockAccount(coinbase, 'olirocks')
Olicoin_contract.transact({'from': coinbase}).set_ContractAddress(Olidaughter_address,True)


# In[ ]:


#########BILATERAL TRADE#########
#set oli origin Address
web3.personal.unlockAccount(coinbase, 'olirocks')
Olibilateral_contract.transact({'from': coinbase}).setOliOrigin(Oliorigin_address)


# In[ ]:


#########DAUGHTER AUCTION########

#set oli origin Address

web3.personal.unlockAccount(coinbase, 'olirocks')
Olidaughter_contract.transact({'from': coinbase}).setOliOrigin(Oliorigin_address)

#set OLIcoin address
web3.personal.unlockAccount(coinbase, 'olirocks')
Olidaughter_contract.transact({'from': coinbase}).setOliCoin(Olicoin_address)


#set DynamicGridFee address
web3.personal.unlockAccount(coinbase, 'olirocks')
Olidaughter_contract.transact({'from': coinbase}).setDynamicGridFee(DynamicGridFee_address)

#set BilateralTrade address
web3.personal.unlockAccount(coinbase, 'olirocks')
Olidaughter_contract.transact({'from': coinbase}).setBilateralTrading(Olibilateral_address)


# In[ ]:


#########Dynamic Grid Fee#######
#set oli origin Address
web3.personal.unlockAccount(coinbase, 'olirocks')
DynamicGridFee_contract.transact({'from': coinbase}).setOliOrigin(Oliorigin_address)


# In[ ]:


###Set Min/Max Grid Fee###
web3.personal.unlockAccount(coinbase, 'olirocks')
DynamicGridFee_contract.transact({'from': coinbase}).set_minmaxgfee(account_21, [4,6,1,3])


# In[13]:


#OLIDaughterAuction1 bid


oliBoxLive = random.randint(500,6250); 


run = 1
while run == 1:
    
    
    #distribute eth from coinbase to the other accounts
    web3.personal.unlockAccount(web3.eth.coinbase, 'olirocks')
    transferAmount = round((web3.eth.getBalance(web3.eth.coinbase) * 0.01))
    for i in range(1,11):
        web3.personal.unlockAccount(web3.eth.coinbase, 'olirocks')
        web3.eth.sendTransaction({'to': web3.eth.accounts[i], 'from': web3.eth.coinbase, 'value': transferAmount})
    
    
    
    oliBoxLive = random.randint(500,6250);
    web3.personal.unlockAccount(account_1, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(500,6500), 3).transact({'from': account_1})
    #Olidaughter_contract.transact({'from': account_1}).bid(oliBoxLive, 3)

    web3.personal.unlockAccount(account_2, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(1000,1050), 10).transact({'from': account_2})
    #Olidaughter_contract.transact({'from': account_2}).bid(random.randint(1000,1050), 10)

    web3.personal.unlockAccount(account_3, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(500,550), 13).transact({'from': account_3})
    #Olidaughter_contract.transact({'from': account_3}).bid(random.randint(500,550), 13)

    web3.personal.unlockAccount(account_4, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(2000,2050), 14).transact({'from': account_4})
    #Olidaughter_contract.transact({'from': account_4}).bid(random.randint(2000,2050), 14)

    web3.personal.unlockAccount(account_5, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(1550,1600), 15).transact({'from': account_5})
    #Olidaughter_contract.transact({'from': account_5}).bid(random.randint(1550,1600), 15)

    #    time.sleep(15)

    web3.personal.unlockAccount(account_6, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(1000,1050), 9).transact({'from': account_6})
    #Olidaughter_contract.transact({'from': account_6}).bid(random.randint(1000,1050), 9)

    web3.personal.unlockAccount(account_7, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(1500,1550), 10).transact({'from': account_7})
    #Olidaughter_contract.transact({'from': account_7}).bid(random.randint(1500,1550), 10)

    web3.personal.unlockAccount(account_8, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(2000,2550), 12).transact({'from': account_8})
    #Olidaughter_contract.transact({'from': account_8}).bid(random.randint(2000,2550), 12)

    web3.personal.unlockAccount(account_9, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(1000,1050), 13).transact({'from': account_9})
    #Olidaughter_contract.transact({'from': account_9}).bid(random.randint(1000,1050), 13)

    web3.personal.unlockAccount(account_10, 'olirocks')
    Olidaughter_contract.functions.bid(random.randint(3000,3050), 14).transact({'from': account_10})
    #Olidaughter_contract.transact({'from': account_10}).bid(random.randint(3000,3050), 14)

    time.sleep(30)
    
    #MCP
    web3.personal.unlockAccount(coinbase, 'olirocks')
    Olidaughter_contract.functions.breakEven().transact({'from': coinbase})
    #Olidaughter_contract.transact({'from': coinbase}).breakEven()    
    time.sleep(30)
    web3.personal.unlockAccount(coinbase, 'olirocks')
    Olidaughter_contract.functions.resett().transact({'from': coinbase})
    #Olidaughter_contract.transact({'from': coinbase}).resett()    
    time.sleep(30)


# In[ ]:


#distribute eth from coinbase to the other accounts
web3.personal.unlockAccount(web3.eth.coinbase, 'olirocks')
transferAmount = round((web3.eth.getBalance(web3.eth.coinbase) * 0.02))
for i in range(1,22):
    web3.personal.unlockAccount(web3.eth.coinbase, 'olirocks')
    web3.eth.sendTransaction({'to': web3.eth.accounts[i], 'from': web3.eth.coinbase, 'value': transferAmount})


# In[12]:


web3.fromWei(web3.eth.getBalance(web3.eth.accounts[2]), 'ether')


# In[10]:


web3.eth.coinbase

