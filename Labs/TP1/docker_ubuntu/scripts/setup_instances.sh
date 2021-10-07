#!/bin/bash

# VARIABLES USED TO PRINT WHEN NOT RUNNING
REFRESH_RATE=5;

# Function to start the instances
function start_instances(){
  aws ec2 start-instances --instance-ids "$@" > /dev/null ;
}
# Function to wait until the instance is running
function check_running(){
  while true
  do
    value=$(aws ec2 describe-instances --filters Name=instance-id,Values="$@"  --query 'Reservations[*].Instances[*].State.[Name]'  --output text );
    if [ "$value" == "running" ]; then
      echo "Instance $@ is $value.";
      break;
    else
        echo "Instance $@ is $value. Waiting for running";
        sleep $REFRESH_RATE;
    fi
  done
}
# Function to loop over the instances
function check_all_running(){
    for id in "$@";
    do check_running $id;
    done;
}

# Function to start the instances
function launch_instances(){
  echo "START LAUNCHING INSTANCES";
  start_instances "$@";
  check_all_running "$@";
  echo "STOP LAUNCHING INSTANCES";
}

launch_instances "$@"