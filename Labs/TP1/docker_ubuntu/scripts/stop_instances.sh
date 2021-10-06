#!/bin/bash

# Function to start the instances
function stop_instances(){
  aws ec2 stop-instances --instance-ids "$@" > /dev/null;
}

# Function to wait until the instance is stopped
function check_stopping(){
  while true
  do
    value=$(aws ec2 describe-instances --filters Name=instance-id,Values="$@"  --query 'Reservations[*].Instances[*].State.[Name]'  --output text );
    if [ "$value" == "stopped" ]; then
      echo "Instance $@ is $value.";
      break;
    else
        echo "Instance $@ is waiting for stopping";
        sleep 2;
    fi
  done
}

# Function to loop over the instances
function check_all_stopping(){
    for id in "$@";
    do check_stopping $id;
    done;
}

# Function to start the instances
function reset_instances(){
  echo "START STOPPING INSTANCES";
  stop_instances "$@";
  check_all_stopping "$@";
  echo "ALL INSTANCES ARE STOPPED";
}

reset_instances "$@"