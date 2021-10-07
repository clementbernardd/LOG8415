#!/bin/bash

# Start the instances and then the target group
function setup_cluster(){
  bash $PATH_TO_SCRIPT/setup_instances.sh "$@";
  bash $PATH_TO_SCRIPT/setup_target_group.sh "$@";
}
# Stop the instances and detach them to the target group
function stop_cluster(){
  bash $PATH_TO_SCRIPT/stop_instances.sh "$@";
  bash $PATH_TO_SCRIPT/detach_target_group.sh "$@";
}

# Run the scenario
function run_scenario(){
  setup_cluster "$@";
  python3 -m $PATH_TO_PYTHON_SCRIPT run_scenario --url=$ELB_URL;
  stop_cluster "$@";
}

run_scenario "$@"
