#!/bin/bash


function start_elb_and_tg(){
  bash $PATH_TO_SCRIPT/start_load_balancer.sh ;
  bash $PATH_TO_SCRIPT/start_target_group.sh ;
  bash $PATH_TO_SCRIPT/add_listener.sh ;
}

function stop_elb_and_tg(){
  bash $PATH_TO_SCRIPT/stop_listener.sh;
  bash $PATH_TO_SCRIPT/stop_load_balancer.sh ;
  bash $PATH_TO_SCRIPT/stop_target_group.sh ;
}

function launch_setup(){
  if [ $1 = 'start' ] ; then
    echo "LAUNCH SETUP";
    start_elb_and_tg;
  else
    echo "END SETUP";
    stop_elb_and_tg;
  fi
}

launch_setup "$@"



