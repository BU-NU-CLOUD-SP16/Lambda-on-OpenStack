#!/usr/bin/env python

import os
import sys


# CONSTANTS
FILE_PATH = os.getcwd() + '/../../UI/uploads'

class Estrator:
	"orchestrator component which contains all the logic for identifying the functions and the parameters for provisioning."
	def createProvisioningEnvironment(self, params):
		# eventType = params["event_data"]["type"] or ""
		# eventData = params["event_data"]["filename"] or ""
		# username =  params["user_name"] or ""
		# eventSource = params["event_source"] or ""
		# sourceFile = identifyFunctionFor(username, eventSource, eventType)
		# nodesRequired  = computeNumberOfNodes()
		# network = CreateNetworkEnvironment()

	def test(self, params):
		print("this is test")

	