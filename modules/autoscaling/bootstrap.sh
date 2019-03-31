#!/bin/bash
wget https://s3-us-west-2.amazonaws.com/terraform-in-action/server -O /run/server
mkdir /run/public
wget https://s3-us-west-2.amazonaws.com/terraform-in-action/static.zip -O /run/public/static.zip
unzip /run/public/static.zip
mv build/* /run/public
rm -rf build
chmod 755 server
/run/server