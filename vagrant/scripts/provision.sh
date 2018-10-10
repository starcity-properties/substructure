#!/bin/bash


for USER in $(echo ${users})
do
    sudo useradd -m $USER -p $USER

    sudo su --login $USER

    cd /home/$USER
    mkdir .ssh
    chmod 700 .ssh
    chown $USER:$USER .ssh

    cat /tmp/authorized_keys >> .ssh/authorized_keys
    chmod 600 .ssh/authorized_keys
    chown $USER:$USER .ssh/authorized_keys
done


# install vagrant



git clone https://github.com/starcity-properties/hologram
# run vagrant dev up
# run vagrant dev ssh

# a) build application and run as demo
# vagrant dev share --http

# b) share ssh access
# vagrant dev share --ssh

# c) perform code review
# git clone/pull repo, build, run
# OR pull from ECR




