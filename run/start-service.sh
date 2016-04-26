#start lambda servie
#!/bin/sh
#cd /home/ubuntu/Lambda-on-OpenStack/LambdaService/Provision/
#source LambdaOnOpenstack-openrc.sh
cd /home/ubuntu/Lambda-on-OpenStack/LambdaService/EventListener/
python queueReceiver.py 



