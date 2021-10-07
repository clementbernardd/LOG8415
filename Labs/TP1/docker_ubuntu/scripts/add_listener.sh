#!/bin/bash

LOAD_BALANCER_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].LoadBalancerArn' --output text)
TARGET_GROUP_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[0].TargetGroupArn' --output text)

function add_listener(){
  echo "ADD LISTENER";
  aws elbv2 create-listener --load-balancer-arn $LOAD_BALANCER_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN --region us-east-1 > /dev/null;
  echo "END ADD LISTENER";
}

add_listener