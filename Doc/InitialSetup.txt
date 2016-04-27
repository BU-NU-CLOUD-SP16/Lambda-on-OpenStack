Lambda initial setup:

This is a document to setup inital lambda environment on OpenStack cloud using Nova.

Prerequisites:

* A virtual machine with Ubuntu 14.0 is provisoned and will be used as master for the service.
* LambdaOnOpenstack-openrc.sh file downloaded and copied on the master.
* The key pair downloaded and copied on the master that will used to provision and access all the child virtual machines to be created in future
* The required packages installed to setup the environment using the given installation scripts



Install the required packages:

* Run master-script.sh at Lambda-on-OpenStack/install that will install the required packages for the master to setup an environment



Provision and setup the first child node:

At this point, first child node should be provisioned and configured for providing an environment to execute lambda functions.

* Update the location of key pair .pem file in setup.config file present in Lambda-on-OpenStack directory. Provide other provisioning parameters for VM provisioning like flavor, image, network etc.

* Run LambdaOnOpenstack-openrc.sh file to setup the environment variables in order to communicate with Nova compute service on Openstack.
Note: Run LambdaOnOpenstack-openrc.sh file before every execution of the script on every new terminal being used for execution

* Run create_snapshot.sh to provision and setup a child virtual machine/node and generate a snapshot of this virtual machine for provisioning of the nodes in future. 

* Save the VM_IP returned at the end of execution of the script. This is the IP of the child node created during the previous step.

* Run cluster_setup.sh with child node IP returned in the previous step and master node IP i.e. the IP of the node where the service will run. This will create a Swarm cluster with a consul discovery service, a manager on the master node and the child node federated to the swarm cluster
e.g. ./cluster_setup.sh <child-node ip> <master-node ip>
     ./cluster_setup.sh 192.168.1.101 192.168.1.3
	 
Setting up the Swarm cluster will provdide the initial configuration for the lambda service to execute the functions

Next step will be to start the services on the master that will listen to events from the user or system.



Starting the service:

* Run LambdaOnOpenstack-openrc.sh file to setup the environment variables in order to communicate with Nova compute service on Openstack.

* Run start-lambda-service.sh present in the ./Lambda-on-OpenStack/run directory. This will start the queue listener service that will receive the event for function execution. It will start a daemon process that will monitor the resource utilization across all the nodes in the cluster and provision & deprovision the nodes on per the load on cluster. It will also start a sinarta server which will listen to user inputs using cURL commands.

Note: cURL API documentation can be found at Lambda-on-OpenStack/UserInterface/API/html/index.html
 

