#!/usr/bin/env python
import os
import sys
import time

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

provision = Provision()
database = Database()

class Estrator:
	def createEnvironment(self, params):

		eventType = params["event_data"]["type"] or ""

		# TODO - logic for computing the parameters of machines will be go here.

		# eventData = params["event_data"]["filename"] or ""
		# username =  params["user_name"] or ""
		# eventSource = params["event_source"] or ""
		

		flavourName = self._get_flavour_name()
		username = self.__get_user_name()
		imageName = self.__get_image_name()
		serverName = self.__get_server_name()
		network = self.__create_network_environment()
		sourceFile = self.__identify_function_for(username)
		server_request_object = {"username":username, "image_name":imageName, "network_name":network, "server_name":serverName,"flavor_name":flavourName}
		# provision.delete_instance(serverName)
		# provision.create_instance(server_request_object)
		# time.sleep(20)
		deploy_request_obj = {"server_name":serverName,"network_name":network,"username":username, "function_name":sourceFile}
		provision.deploy_and_execute_docker(deploy_request_obj)


# most of the functions below are placeholder functions which will be modified to contain logic for doing the job using Openstack API's
	
	def __identify_function_for(self, username):
		return 'test.py'

	def __create_network_environment(self):
		return "test-network"

	def __get_server_name(self):
		return "vm2"

	def __get_image_name(self):
		return "ubuntu-14.04"	

	def __get_user_name(self):
		return "ubuntu"

	def _get_flavour_name(self):
		return "m1.medium"

