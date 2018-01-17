import urllib2
import json
import paho.mqtt.publish as publish
import time

host="m23.cloudmqtt.com"
port= 10094
username="kabknwly"
password="3JmAU0Tm9nUr"
power=0

url= "http://localhost:1080/api/1/power/now"
while 1:
        json_obj= urllib2.urlopen(url)
        data = json.load(json_obj)
        serial= data["serial"]
        name= data["name"]
        timestamp= data["time"]
        topic="OLI/"+name+"/"+serial
        for item in data['datasets']:
                for item2 in item['phases']:
                        for item3 in item2['values']:
                                power= item3['data']
                                pT=str(power)+"?"+str(timestamp)
                                print pT
        publish.single(topic,payload=str(pT),hostname=host, port=port, auth={'username':username,'password':password})
        print("Done "+topic)
        time.sleep(3000)
