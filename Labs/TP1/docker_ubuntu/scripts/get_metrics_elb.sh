#!/bin/bash

function get_metric_elb(){
  metric_name=$1;
  output_dir=$current_directory_elb/$metric_name/ ;
  mkdir -p $output_dir ;
  echo "CURRENT METRIC : $metric_name";
  metrics=$(aws cloudwatch get-metric-statistics --namespace AWS/ApplicationELB --metric-name $metric_name  --statistics Sum  --dimensions Name=LoadBalancer,Value=$ELB_NAME_METRIC  --start-time $START_TIME --end-time $END_TIME --period $PERIOD_FOR_METRIC);
  echo $metrics > $output_dir/elb.json;
}

function get_metrics_elb(){
  cat $path_to_save_all_elb_metrics | while read line
  do
    get_metric_elb $line;
  done
}

# Get the available metrics and save them into a file
function setup_available_metrics(){
  export path_to_save_all_elb_metrics=$PATH_TO_SAVE_ALL_METRICS/all_metrics_elb.txt;
  export current_directory_elb=$PATH_TO_METRICS/elb ;
  mkdir -p $current_directory_elb;
  aws cloudwatch list-metrics --namespace AWS/ApplicationELB --query 'Metrics[*].[MetricName]'  --output text | sort | uniq > path_to_save_all_elb_metrics;
}

function get_metrics(){
  echo "GET THE METRICS ELB"
  setup_available_metrics;
  shift;
  get_metrics_elb ;
  echo "END GET THE METRICS ELB"
}

get_metrics