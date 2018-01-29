import urllib2
import json
import paho.mqtt.publish as publish
import time

host="m23.cloudmqtt.com"
port= 10094
username="user"
password="pass"
power=0

url= "http://localhost:1080/api/all/power/now"
while 1:
        my_list = []
        json_obj= urllib2.urlopen(url)
        data = json.load(json_obj)
        serial= data["serial"]
        name= data["name"]
        timestamp= data["time"]
        topicP="OLI_Power/"+name+"/"+serial
        topicE="OLI_Energy/"+name+"/"+serial
        f= open("/var/smartpi/consumecounter", "r")
        energy = f.read()
        for item in data['datasets']:
                for item2 in item['phases']:
                        for item3 in item2['values']:
                                power= item3['data']
                                my_list.append(power)
                                pT=str(power)+"?"+str(timestamp)
                                print power
        msgs =[{'topic':topicP,'payload':"Phase1:"+str(my_list[0])},(topicP,"Phase2:"+str(my_list[1]),0,False),(topicP,"Phase3:"+str(my_list[2])),(topicP,"Phase                                                                                                             4:"+str(my_list[3])),(topicP,"Timestamp:"+str(timestamp))]
        publish.multiple(msgs,hostname=host, port=port, auth={'username':username,'password':password})
        publish.single(topicE,payload=str(energy),hostname=host,port=port,auth={'username':username,'password':password})
        print("Done "+topicP)
        print("Done "+topicE)
        print "Energy="+energy
        print my_list
        f.close()
        time.sleep(900)
