#!/bin/bash

ELB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].LoadBalancerArn' --output text)

function delete_load_balancer(){
  echo "DELETE LOAD BALANCER";
  aws elbv2 delete-load-balancer --load-balancer-arn  $ELB_ARN;
  echo "DELETE WITH SUCCESS";
}

delete_load_balancer
