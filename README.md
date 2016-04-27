#Lambda on Openstack or Function as a Service

Contents:
1. Project outline
2. Scope
3. Workflow
3. Components
4. Setup

1. Project Outline: 
Lambda on openstack is a serverless compute service that allows a user to uplaod a function in the Openstack cloud environment which can be invoked in response to an event. A user can do this without getting into provisioning, configuration, and maintainance of virtual machines on the cloud. The resources are provisioned and the code is executed on an event and the resources are released as soon as execution ends. It auto-scales for every service as they are stateless and every request is treated as a new request irrespective of the soruce of the event. The events are received on queue service that is installed along with lambda Service installation. A listener in the service listens to this queue and invokes a corresponding function based on event data.

This allows users to focus on development rather than managing the environment.
  
This project focuses to provide an execution platform for one-way fucntions executed on events that are pulled from a repository or a stream asynchronously on [Masachusetts Open Cloud (MOC)](https://rc.fas.harvard.edu/partnerships/massachusetts-open-cloud-moc/) with a vision to provide a synchronous two-way capabilities and package it to be deployed on any cloud that works on [OpenStack](https://www.openstack.org/).

2. Scope:
Following are the objectives of this project:
a. Develop a serverless platform which alows users to get their code get executed fast.
b. Save the users from infrastructure management and problems about utilization of resources. 
c. Having an extensible platform which can be extended to run multiple environments. Using Docker containers gives us the flexibility to create a new execution environment quickly.
d. Develop a service which can listen to events coming in a particular queue.
e. Acheive Microservice architecture which will allow us to acheive fast development and deployment.
f. Autoscale the running of machines 
g. There is no cost evaluation and user authorization, authentication.
h. Only command line interface to interact with the lambda service. A user can upload function with required details using curl commands; usage of which are present in the swagger documentation.
i. Only python execution environment currently.
j. A testing service is present in the package which can be used to test the lambda service.


3. A typical workflow:
The userbase for Lambda service could be identified as:
a. Cloud Platforms supporting Openstack: As a cloud provider supporting openstack, a user can setup Lambda on openstack and provide it as PAAS solution to the end users.
b. End users/Developers : As an end user, a developer can use Lambda on Openstack to upload a function and configure it to get executed based on an event.


4. Components:
Lambda on openstack has 4 Major components - 
a. Queing service: This service holds the event details that are pushed by a service that wants to interact with the lambda  Service.
b. CLI interfaceL This component lets a user to upload a function along with required details like memory, event source, environment to to run the function. 
c. MongoDB: The database layer is implemented in mongodb which holds the details about the user, function, function details and the relational link between them
c. Lambda Service: This is the core of the Lambda on Openstack. Containing a queue listener and a provision component, it listens to an event from the Queing service, fetches the function details based on event data, provision a container in the cluster and executed the code.


5. Typical User flow includes: 
a. A user uplaods a function(called as lambda function) to the lambda service using the CLI interface.(curl commands, reference present in the /UserInterface/curl.txt)
b. The user configures the FileCreateService.rb with the correct filename and event details in terms of memory, username, event type, event source to fire the event.
c. The event is picked up by the lambda service and executed on containers created VM present in the cluster..


Details about the setup can be found at: LambdaonOpenstack/Doc/initialSetup.txt




