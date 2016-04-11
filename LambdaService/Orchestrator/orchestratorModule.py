#!/usr/bin/env python
import os
import sys
import time
import uuid

path = os.path.realpath('Provision.py')
folder = path.split("/")
l = len(folder)
a = ''
for x in folder[0:l-2]:
    a = a+'/'+x
print('--File path----'+a)    
sys.path.append(a+ '/Provision')
sys.path.append(a+ '/Database')
from Provision import Provision
from Database import Database

class Estrator:
	def __init__(self):
		self.provision = Provision()
		self.database = Database()


	def createEnvironment(self, params):

		eventType = params["event_data"]["type"] or ""
		filename = ""
		functionName = params["event_data"]["filename"]
		eventSource = params["event_source"]

		
		username = params["user_name"]
		imageName = self.__get_image_name()
		serverName = self.__get_server_name()
		network = self.__create_network_environment()

		result = self.__identify_function_for(username, functionName, eventSource)
		if result.count()==0:
			print("not matching records found for the event.")
		else:	
			filename = result[0]["filename"]
			memory - result[0]["memory"]
			self.__write_file_data_to_location(result[0]["_id"], filename)
			log_uuid = self.__get_uuid()
			self.__update_sequence_count(username, functionName, eventSource, log_uuid)
			flavourName = self._get_flavour_name(memory)
			server_request_object = {"username":username, "image_name":imageName,
									 "network_name":network, "server_name":serverName,
									 "flavor_name":flavourName}

			deploy_request_obj = {"server_name":serverName,"network_name":network,"username":username, "function_name":filename}
			self.provision.deploy_and_execute_docker(deploy_request_obj,log_uuid)


# most of the functions below are placeholder functions which will be modified to contain logic for doing the job using Openstack API's
	
	def __identify_function_for(self, username, functionName, eventSource):
		return self.database.findData(username, functionName, eventSource)
	def __update_sequence_count(self, username, functionName, eventSource, log_uuid):
		return self.database.updateSequenceCount(username, functionName, eventSource, log_uuid)

	def __get_uuid(self):
		return uuid.uuid4()
		
	def __write_file_data_to_location(self, objId, filename):
		return self.database.writeFile(objId, filename)

	def __create_network_environment(self):
		return "test-network"

	def __get_server_name(self):
		return "vm2"

	def __get_image_name(self):
		return "ubuntu-14.04"	

	def __get_user_name(self):
		return "ubuntu"

	def _get_flavour_name(self, memory):
		return memory>=1000?"m1.medium":"m1.small"

