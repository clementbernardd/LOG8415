#!/bin/bash

# Attach instance to the target group
function attach_instance_to_target_group(){
    aws elbv2  register-targets --target-group-arn $TARGET_ARN --targets Id="$@" > /dev/null;
}
# Attach all the instances
function attach_all_instances_to_target_group(){
  for id in "$@";
  do attach_instance_to_target_group $id ;
  done ;
}
# Check the health of the instances in the target group
function check_instance_health(){
  while true ;
  do
    value=$(aws elbv2 describe-target-health --target-group-arn $TARGET_ARN --targets Id="$@" --query 'TargetHealthDescriptions[*].TargetHealth[].State' --output text);
    if [ "$value" == "healthy" ]; then
        echo "Instance $@ is $value for target group ARN $TARGET_ARN";
        break;
    else
        echo "Instance $@ is $value. Waiting for health";
        sleep 2;
    fi
  done
}

# Check target health
function check_target_health(){
  for id in "$@"
  do check_instance_health $id;
  done;
}
# Set all the target group
function set_target_group(){
  echo "START TO ATTACH INSTANCES TO TARGET GROUP";
  attach_all_instances_to_target_group "$@";
  check_target_health "$@";
  echo "END TO ATTACH INSTANCES TO TARGET GROUP";
}

set_target_group "$@"