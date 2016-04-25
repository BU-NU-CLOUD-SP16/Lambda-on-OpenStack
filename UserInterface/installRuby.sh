# unzip 'LambdaOnOpenstack.zip'
# cd Lambda-on-OpenStack/UserInterface

RUBY= $(which ruby);

if [[ -n "$RUBY" ]]; 
	then
	echo "Ruby is already installed"
	
else
	echo "installing ruby"
	echo "enter system password to proceed."
	sudo apt-get install python-software-properties
	sudo apt-add-repository ppa:brightbox/ruby-ng
	sudo apt-get update
	sudo apt-get install ruby2.3
	sudo apt-get install ruby-switch
fi
