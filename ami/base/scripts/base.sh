#!/usr/bin/env bash
set -xe

# prevent automatic apt updates/upgrades
# this can mess with provisioning apt usage
sudo systemctl stop apt-daily.service
sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer

# upgrade packages
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# ec2 meta-data tool
curl http://s3.amazonaws.com/ec2metadata/ec2-metadata --silent > /usr/local/bin/ec2-metadata
sudo chmod u+x /usr/local/bin/ec2-metadata
sudo chown ubuntu:users /usr/local/bin/ec2-metadata

# install base packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y awscli curl clamav clamav-daemon nmap

# install java
sudo add-apt-repository -y ppa:webupd8team/java
sudo echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer oracle-java8-unlimited-jce-policy

# install codedeploy agent
sudo mkdir -p /etc/apt/sources.list.d
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
cat <<EOF | sudo tee /etc/apt/sources.list.d/brightbox-ubuntu-ruby-ng-wily.list
deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu wily main
EOF
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ruby2.0

curl https://raw.githubusercontent.com/aws/aws-codedeploy-agent/master/bin/install > /tmp/codedeploy-install
chmod a+x /tmp/codedeploy-install
sudo /tmp/codedeploy-install auto
sudo systemctl stop codedeploy-agent
sudo systemctl disable codedeploy-agent

# install nginx
sudo add-apt-repository -y ppa:nginx\/stable
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

sudo rm -rf /etc/nginx/sites-enabled/default
sudo service nginx stop

# ntp crontab
echo "* */1 * * * /usr/sbin/ntpdate ntp.ubuntu.com pool.ntp.org" >> /tmp/crontab.tmp
crontab /tmp/crontab.tmp
rm /tmp/crontab.tmp

TAG_NAME="Type"
INSTANCE_ID=""
TAG_VALUE="``"

# aliases for reading EC2 boot log
sudo bash -c 'cat << "EOF" > /home/ubuntu/.bash_aliases
alias clog="cat /var/log/cloud-init-output.log"
alias clogf="tailf /var/log/cloud-init-output.log"
EOF'

chmod 644 /home/ubuntu/.bash_aliases
sudo chown ubuntu:ubuntu /home/ubuntu/.bash_aliases

sudo chown ubuntu:ubuntu /opt

# ops
sudo mkdir -p /ops
sudo chown -R ubuntu:ubuntu /ops

echo Cleaning up...
sudo apt-get -y autoremove
sudo apt-get -y clean

sudo rm -rf /tmp/*
