Lambda service component in Python.

This compute serive which executes a function uploaded by a user according to a pre-defined event listened from a queue.
This component creates a ques listener which listens for events and provisions machines in public cloud using Openstack API's based on the user provided parameters and internally computed parameters.

Currently it has following components:
1. EventListener : Listens to a queue.
2. orchestrator: contains the logic to identify the function corresponding to a user and resources needed to provision machines.
3. Provision : Provisions machines using openstack API's based on parameters computed from Orchestrator.


To run the service, run the following commands from command line:
Assumption : You have python and pip installed.

1. pip install -r requirements.txt
2. python queueReceiver.py