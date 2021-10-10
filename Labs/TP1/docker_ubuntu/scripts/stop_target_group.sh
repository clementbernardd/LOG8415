#!/bin/bash


TARGET_ARN=$(aws elbv2 describe-target-groups --query 'TargetGroups[0].TargetGroupArn' --output text)


function delete_target_group(){
  aws elbv2 delete-target-group --target-group-arn $TARGET_ARN;
}

function end_target_group(){
  echo "START STOPPING TARGET GROUP";
  delete_target_group;
  echo "END STOPPING TARGET GROUP";
}

end_target_group
