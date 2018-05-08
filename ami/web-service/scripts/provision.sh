#!/usr/bin/env bash
set -xe

sleep 30

# upgrade packages
sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
