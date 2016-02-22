#!/usr/bin/env python

import pika
import simplejson as json
from validator import Validator
# from orchestrator import Estrator


import os
import sys    
path = os.path.realpath('orchestrator.py')
folder = path.split("/")
l = len(folder)
a = ''
for x in folder[0:l-2]:
    a = a+'/'+x
print('--File path----'+a)    
sys.path.append(a+ '/Orchestrator')
from orchestrator import Estrator


# helper class instantantiation
orch = Estrator()
validator = Validator()
######


connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='lambda Queue')

def callback(ch, method, properties, body):
    if body is None:
    	print("Error: Empty event Received")	
    else:	
    	if validator.validatePayload(body):
    		stringData = str(body)
    		jsonData = json.loads(stringData.replace("=>", ":"))
    		payload = jsonData
    		print(" [x] Received %r" % payload)
    		print("starting provisioning of machines.")
    		orch.createProvisioningEnvironment(body)



channel.basic_consume(callback,
                      queue='lambda Queue',
                      no_ack=True)

print(' [*] Waiting for messages. To exit press CTRL+C')
channel.start_consuming()