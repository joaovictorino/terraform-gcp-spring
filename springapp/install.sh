#!/bin/bash

sudo apt-get update
sudo apt-get install -y openjdk-11-jre unzip
mkdir /home/ubuntu/springmvcapp
rm -rf /home/ubuntu/springmvcapp/*.*
unzip -o /home/ubuntu/springapp/springapp.zip -d /home/ubuntu/springmvcapp
sudo mkdir -p /var/log/springapp
sudo cp /home/ubuntu/springapp/springapp.service /etc/systemd/system/springapp.service
sudo systemctl start springapp.service
sudo systemctl enable springapp.service
