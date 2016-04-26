#!/bin/sh


gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
#\curl -sSL https://get.rvm.io | bash -s stable --ruby
\curl -sSL https://get.rvm.io | bash
`source /home/ubuntu/.rvm/scripts/rvm` 
rvm install 2.3-dev
#rvm use 2.3.0-dev
gem install bundler
cd /home/ubuntu/Lambda-on-OpenStack/UserInterface/
bundle update
