#!/bin/bash
set +x
#echo "This is from new script using yum packages."
sudo yum update –y
sudo amazon-linux-extras install ansible2 -y
ansible — version
