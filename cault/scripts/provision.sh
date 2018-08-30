#!/bin/bash


# NOTE: Currently these commands must be run manually
# because the Packer-built AMI considers itself already provisioned,
# meaning the user_data script is not automatically run on launch.


cd /cault

docker-compose up -d
