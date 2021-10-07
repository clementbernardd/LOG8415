#!/bin/bash

# CLUSTER 1 - Instance IDs
export M4_INSTANCE_1_ID=i-00caa819bf2c41b94
export M4_INSTANCE_2_ID=i-07219639aa5a658c0
export M4_INSTANCE_3_ID=i-0a98bada8189bdd12
export M4_INSTANCE_4_ID=i-0bac46a901059925a


# CLUSTER 2 - Instance IDs

export T2_INSTANCE_1_ID=i-06250357f90f9c9ec
export T2_INSTANCE_2_ID=i-08427682b56a53495
export T2_INSTANCE_3_ID=i-0ba25b6cfe9d7851b
export T2_INSTANCE_4_ID=i-0c4591996f5bed860

# All the instances to facilitate the commands

export T2_INSTANCES_LIST="$T2_INSTANCE_1_ID $T2_INSTANCE_2_ID $T2_INSTANCE_3_ID $T2_INSTANCE_4_ID"
export M4_INSTANCES_LIST="$M4_INSTANCE_1_ID $M4_INSTANCE_2_ID $M4_INSTANCE_3_ID $M4_INSTANCE_4_ID"

# Target ARN
do_exportation_tg(){
  export TARGET_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[0].TargetGroupArn' --output text)
}

# LOAD BALANCER URL
function do_exportation_elb(){
  export ELB_NAME=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].DNSName'  --output text)
  export ELB_URL=http://$ELB_NAME
  export ELB_ARN=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].LoadBalancerArn' --output text)
  export ELB_NAME_METRIC=$(echo $ELB_ARN | sed  -E "s/(.*)(app\/.*)/\2/")
}

# Security group
export SECURITY_GROUP_NAME_CLUSTER1=sg-0004075752527c784
export SECURITY_GROUP_NAME_CLUSTER2=sg-0dc4b54ef41d9df80
export SECURITY_GROUP_LOAD_BALANCER=sg-0dee5102851d1766b

# Path to python files
export PATH_TO_PYTHON_SCRIPT=python.py_script
export PATH_TO_VISUALIZE_INSTANCE_METRICS=python.plot_script_instances
export PATH_TO_VISUALIZE_ELB_METRICS=python.plot_script_load_balancer


export START_TIME=$(TZ=UTC+2 date -R  '+%Y-%m-%dT00:00:00')
export END_TIME=$(TZ=UTC-2 date -R  '+%Y-%m-%dT23:00:00')

export PATH_TO_SCRIPT=scripts
export PATH_TO_METRICS=metrics/results
export PATH_TO_SAVE_ALL_METRICS=metrics/available_metrics
export PERIOD_FOR_METRIC=120



function run_all(){
  # Setup of the ELB and target group
  bash $PATH_TO_SCRIPT/setup_elb_and_tg.sh 'start';
#   Export the ARN, DNS and other useful informations
  do_exportation_elb;
  do_exportation_tg;
  # Do the scenario for each cluster
  bash $PATH_TO_SCRIPT/run_scenario.sh $T2_INSTANCES_LIST
  bash $PATH_TO_SCRIPT/run_scenario.sh $M4_INSTANCES_LIST
  # Get the metrics
  bash $PATH_TO_SCRIPT/get_metrics.sh 1  $M4_INSTANCES_LIST
  bash $PATH_TO_SCRIPT/get_metrics.sh 2  $T2_INSTANCES_LIST
  bash $PATH_TO_SCRIPT/get_metrics_elb.sh

  # Plot the metrics
  python -m $PATH_TO_VISUALIZE_INSTANCE_METRICS --path=$PATH_TO_METRICS plot_instances
  python -m $PATH_TO_VISUALIZE_ELB_METRICS --path=$PATH_TO_METRICS plot_elb_metrics
  # Delete the load balancer and target group
  bash $PATH_TO_SCRIPT/setup_elb_and_tg.sh 'end';
}

run_all ;

