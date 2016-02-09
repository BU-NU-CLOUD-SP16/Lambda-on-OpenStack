#Function as a Service or Lambda on Openstack

"Function as a service" is a utility similar to [AWS Lambda](https://aws.amazon.com/lambda/) that provides a platform to the users to expose their code as a service that gets executed on an event, without getting into provisioning, configuration, and maintainance of virtual machines on the cloud. The resources are provisioned and the code is executed on an event and the resources are released as soon as execution ends. It auto-scales for every service as they are stateless and every request is treated as a new request irrespective of the soruce of the event.

This will allow users focus on development rather than managing the environment.

This project focuses to provide an execution platform for one-way fucntions executed on events that are pulled from a repository or a stream asynchronously on [Masachusetts Open Cloud (MOC)](https://rc.fas.harvard.edu/partnerships/massachusetts-open-cloud-moc/) with a vision to provide a synchronous two-way capabilities and package it to be deployed on any cloud that works on [OpenStack](https://www.openstack.org/).

###Developers:
- Ashrith Bangi
- Naomi Joshi
- Rajul Kumar
- Rohit Kumar
- Sushant Mimani