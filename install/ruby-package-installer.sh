#!/bin/sh

apt-get install python-software-properties
apt-add-repository -y ppa:brightbox/ruby-ng
apt-get update
apt-get install -y ruby2.3
apt-get install -y ruby2.3-dev
apt-get install -y ruby-switch

#installing gems
gem install bundler
#cat /home/ubuntu/Lambda-On-OpenStack/install/Gemfile | tr "\r" "\n" > /home/ubuntu/Lambda-On-OpenStack/install/Gemfile
bundle install --path /home/ubuntu/Lambda-On-OpenStack/UserInterface/

