#!/usr/bin/env python
import os
import sys

path = os.path.realpath('Provision.py')
folder = path.split("/")
l = len(folder)
a = ''
for x in folder[0:l-2]:
    a = a+'/'+x
print('--File path----'+a)    
sys.path.append(a+ '/Provision')
from Provision import Provision

provision = Provision()

class Estrator:
	def createEnvironment(self, params):
		eventType = params["event_data"]["type"] or ""
		# eventData = params["event_data"]["filename"] or ""
		# username =  params["user_name"] or ""
		# eventSource = params["event_source"] or ""
		# sourceFile = identifyFunctionFor(username, eventSource, eventType)
		# nodesRequired  = computeNumberOfNodes()
		# network = CreateNetworkEnvironment()
		provision.create_instance()

	