#!/bin/bash

function detach_instance_to_target_group(){
    aws elbv2  deregister-targets --target-group-arn $TARGET_ARN --targets Id="$@";
}

function detach_all_instances_to_target_group(){
  for id in "$@";
  do detach_instance_to_target_group $id ;
  done ;
}


function detach_target_group(){
  echo "START TO DETACH INSTANCES TO TARGET GROUP";
  detach_all_instances_to_target_group "$@";
  echo "END TO DETACH INSTANCES TO TARGET GROUP";
}

detach_target_group "$@"
