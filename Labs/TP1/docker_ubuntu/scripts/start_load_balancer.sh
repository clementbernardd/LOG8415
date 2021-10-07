#!/bin/bash


SUBNETS="subnet-0a7795cc7737f0886 subnet-02e396cfac6baa3ea subnet-0b90192276722432a subnet-00eff7ef587d38f3d subnet-0ef5d871f53d89b8b subnet-0c35f1a755564329f"
LOAD_BALANCER_NAME=loadbalancer
REFRESH_RATE=5

function create_load_balancer(){
  aws elbv2 create-load-balancer --name $LOAD_BALANCER_NAME  --region us-east-1  --security-groups $SECURITY_GROUP_LOAD_BALANCER  --subnets $SUBNETS > /dev/null
}


function check_creation_load_balancer(){
  lb_name=$( aws elbv2 describe-load-balancers --query 'LoadBalancers[0].LoadBalancerName' --output text)
  while true
  do
    value=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].State.Code' --output text);
    if [ "$value" == "active" ]; then
      echo "Load balancer $lb_name is $value.";
      break;
    else
        echo "Load balancer $lb_name is $value. Waiting for setup.";
        sleep $REFRESH_RATE;
    fi
  done
}

function setup_load_balancer(){
  echo "START LAUNCHING LOAD BALANCER";
  create_load_balancer;
  check_creation_load_balancer;
  echo "END LAUNCHING LOAD BALANCER";
}

setup_load_balancer
