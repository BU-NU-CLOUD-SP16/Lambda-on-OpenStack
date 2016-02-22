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

		# TODO - logic for computing the parameters of machines will be go here.

		# eventData = params["event_data"]["filename"] or ""
		# username =  params["user_name"] or ""
		# eventSource = params["event_source"] or ""
		# sourceFile = identifyFunctionFor(username, eventSource, eventType)
		
		flavourName = self._get_flavour_name()
		username = self.__get_user_name()
		imageName = self.__get_image_name()
		serverName = self.__get_server_name()
		network = self.__create_network_environment()

		server_request_object = {"username":username, "image_name":imageName, "network_name":network, "server_name":serverName}
		provision.delete_instance(serverName)
		provision.create_instance(server_request_object)
		time.sleep(20)
		deploy_request_obj = {"server_name":serverName,"network_name":network,"username":username}
		provision.deploy_and_execute(deploy_request_obj)


# most of the functions below are placeholder functions which will be modified to contain logic for doing the job using Openstack API's
	def __create_network_environment(self):
		return "test-network"

	def __get_server_name(self):
		return "vm2"

	def __get_image_name(self):
		return "centos 7"	

	def __get_user_name(self):
		return "centos"

	def _get_flavour_name(self):
		return "m1.medium"

