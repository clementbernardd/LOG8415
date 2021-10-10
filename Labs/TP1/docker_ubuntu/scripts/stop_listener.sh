#!/bin/bash

ELB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].LoadBalancerArn' --output text)

stop_listener(){
  echo "START DELETING LISTENER";
  listener_arn=$(aws elbv2 describe-listeners --load-balancer-arn=$ELB_ARN --query 'Listeners[0].ListenerArn' --output text);
  aws elbv2 delete-listener --listener-arn $listener_arn;
  echo "END DELETING LISTENER";
}

stop_listener;