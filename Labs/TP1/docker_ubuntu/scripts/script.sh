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
export TARGET_ARN=arn:aws:elasticloadbalancing:us-east-1:803716525692:targetgroup/launch-cluster/dc3e7eea76a5761f

# LOAD BALANCER URL
export ELB_NAME=Load-balancer-619524000.us-east-1.elb.amazonaws.com
export ELB_URL=http://$ELB_NAME

export SECURITY_GROUP_NAME_CLUSTER1=sg-0004075752527c784
export SECURITY_GROUP_NAME_CLUSTER2=sg-0dc4b54ef41d9df80

export PATH_TO_PYTHON_SCRIPT=py_script

export START_TIME=2021-10-05T00:00:00
export END_TIME=2021-10-10T00:00:00

#bash run_scenario.sh $T2_INSTANCES_LIST
#bash run_scenario.sh $M4_INSTANCES_LIST