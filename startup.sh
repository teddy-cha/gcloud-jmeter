#!/bin/bash

cd /

ID=$(curl -H "X-Google-Metadata-Request: True" http://metadata/computeMetadata/v1/instance/attributes/id)
CLOUD_STORAGE=""

JMETER_DIR=apache-jmeter-2.9-server

# Set up Open JDK
sudo apt-get update
sudo apt-get install -y openjdk-8-jre
sudo apt-get install -y htop

cd /

# Download JMeter server package
gsutil cp $CLOUD_STORAGE/$JMETER_DIR.tar.gz .
tar zxf $JMETER_DIR.tar.gz
cd $JMETER_DIR

perl -pi -e "s/{{SERVER_PORT}}/24000+$ID/e" bin/jmeter.properties
perl -pi -e "s/{{SERVER_RMI_PORT}}/26000+$ID/e" bin/jmeter.properties

# Start JMeter server.
bin/jmeter-server -Djava.rmi.server.hostname=127.0.0.1
