#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install python3-pip
pip3 install flask gunicorn mysql-connector-python

python3 -m venv myenv
source myenv/bin/activate

mkdir project
cd project
git clone https://github.com/Bhavin-Bhesaniya/AWS-Three-Tier-Architecture-Using-Terraform.git
cd AWS-Three-Tier-Architecture-Using-Terraform
python3 web-tier.py &
gunicorn -w 4 -b 0.0.0.0:80 web-tier:app
