#!/bin/bash

function setup_cluster(){
  bash setup_instances.sh "$@";
  bash setup_target_group.sh "$@";
}

function stop_cluster(){
  bash stop_instances.sh "$@";
  bash detach_target_group.sh "$@";
}

function run_scenario(){
  setup_cluster "$@";
  python3 -m $PATH_TO_PYTHON_SCRIPT run_scenario --url=$ELB_URL;
  stop_cluster "$@";
}

run_scenario "$@"
