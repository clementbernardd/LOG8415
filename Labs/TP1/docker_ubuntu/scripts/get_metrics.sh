#!/bin/bash

function get_metric_instance(){
  metric_name=$1;
  output_dir=$current_directory_ec2/$metric_name/cluster_$cluster_number ;
  mkdir -p $output_dir;
  shift;
  echo "CURRENT METRIC : $metric_name"
  for id in "$@"
    do
    metrics=$(aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name $metric_name --dimensions Name=InstanceId,Value=$id --statistics Sum --start-time $START_TIME --end-time $END_TIME --period $PERIOD_FOR_METRIC);
    echo $metrics > $output_dir/$id.json;
    done
}

function get_metrics_instances(){
  cat $path_to_save_all_ec2_metrics | while read line
  do
    get_metric_instance $line "$@";
  done
}

# Get the available metrics and save them into a file
function setup_available_metrics(){
  export path_to_save_all_ec2_metrics=$PATH_TO_SAVE_ALL_METRICS/all_metrics_ec2.txt;
  export current_directory_ec2=$PATH_TO_METRICS/instances/ ;
  export cluster_number=$1;
  mkdir -p $current_directory_ec2;
  aws cloudwatch list-metrics --namespace AWS/EC2 --query 'Metrics[*].[MetricName]'  --output text | sort | uniq > $path_to_save_all_ec2_metrics ;
}

function get_metrics(){
  echo "GET THE METRICS INSTANCES"
  setup_available_metrics "$@";
  shift;
  get_metrics_instances "$@";
  echo "END GET THE METRICS INSTANCES"
}

get_metrics "$@"