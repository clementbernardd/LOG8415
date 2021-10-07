#!/bin/bash

VPC_ID=vpc-0240ffdc434707882
TARGET_GROUP_NAME=targetgroup

function create_target_group(){
  aws elbv2 create-target-group --name $TARGET_GROUP_NAME --protocol HTTP --port 80 --target-type instance --vpc-id $VPC_ID --region us-east-1 > /dev/null ;
}

function setup_target_group(){
  echo "START LAUNCHING TARGET GROUP";
  create_target_group;
  echo "END LAUNCHING TARGET GROUP";
}

setup_target_group
