# Makefile to make the code clean for the launching process 

###################################################################################################
##################################### IDS, NAMES ##################################################
###################################################################################################

# CLUSTER 1 - Instance IDs

M4_INSTANCE_1_ID=i-00caa819bf2c41b94
M4_INSTANCE_2_ID=i-07219639aa5a658c0
M4_INSTANCE_3_ID=i-0a98bada8189bdd12
M4_INSTANCE_4_ID=i-0bac46a901059925a


# CLUSTER 2 - Instance IDs

T2_INSTANCE_1_ID=i-06250357f90f9c9ec
T2_INSTANCE_2_ID=i-08427682b56a53495
T2_INSTANCE_3_ID=i-0ba25b6cfe9d7851b
T2_INSTANCE_4_ID=i-0c4591996f5bed860


# Target ARN
TARGET_ARN=arn:aws:elasticloadbalancing:us-east-1:803716525692:targetgroup/Cluster1-tg/e1e49a6e50722287

# LOAD BALANCER URL
ELB_NAME=ELB-1226611598.us-east-1.elb.amazonaws.com
ELB_URL=http://$(ELB_NAME)

# All the instances to facilitate the commands
T2_INSTANCES_LIST := "$(T2_INSTANCE_1_ID) $(T2_INSTANCE_2_ID) $(T2_INSTANCE_3_ID) $(T2_INSTANCE_4_ID)"
M4_INSTANCES_LIST := "$(M4_INSTANCE_1_ID) $(M4_INSTANCE_2_ID) $(M4_INSTANCE_3_ID) $(M4_INSTANCE_4_ID)"


SECURITY_GROUP_NAME_CLUSTER1=sg-0004075752527c784
SECURITY_GROUP_NAME_CLUSTER2=sg-0dc4b54ef41d9df80


PATH_TO_PYTHON_SCRIPT:=scripts.py_script

START_TIME=2021-10-05T00:00:00
END_TIME=2021-10-10T00:00:00


#define running_state
#	$$(aws ec2 describe-instance-status | jq '.InstanceStatuses[] | .InstanceState.Name ' | sort | uniq -c  | awk '{print $$1}')
#endef


#define running_state
##	state=$$(aws ec2 describe-instance-status | jq '.InstanceStatuses[] | .InstanceState.Name ' | sort | uniq -c  | awk '{print $$1}')
#	$(1) := $$(aws ec2 describe-instance-status | jq '.InstanceStatuses[] | .InstanceState.Name ' | sort | uniq -c  | awk '{print $$1}')
#endef

#	ALL_RUNNING=$(aws ec2 describe-instance-status | jq '.InstanceStatuses[] | .InstanceState.Name ' | sort | uniq -c  | awk '{print $1}')
#	echo "$(ALL_RUNNING)"
#	[[ $ALL_RUNNING == 4 ]]

#define myfuntest
#  ... compute fnames from $(2) ...
#$(1) := $$(fnames)
#endef




# Generic command to launch instances
cluster_instance_launch:
	aws ec2 start-instances --instance-ids $(INSTANCES)

# Generic command to stop instances
cluster_instance_stop:
	aws ec2 stop-instances --instance-ids $(INSTANCES)

# Launch instances for the cluster1
start_cluster1_instances :
	$(MAKE) cluster_instance_launch INSTANCES=$(M4_INSTANCES_LIST)

# Launch instances for the cluster 2
start_cluster2_instances :
	$(MAKE) cluster_instance_launch INSTANCES=$(T2_INSTANCES_LIST)

# Stop instances for cluster1
stop_cluster1_instances :
	$(MAKE) cluster_instance_stop INSTANCES=$(M4_INSTANCES_LIST)

# Stop instances for cluster 2
stop_cluster2_instances :
	$(MAKE) cluster_instance_stop INSTANCES=$(T2_INSTANCES_LIST)

# Add the instances to the target group
target_register:
	aws elbv2  register-targets --target-group-arn $(TARGET_ARN) --targets Id=$(INSTANCE_ID_1) Id=$(INSTANCE_ID_2) Id=$(INSTANCE_ID_3) Id=$(INSTANCE_ID_4)

# Remove instances to the target group
target_deregister:
	aws elbv2  deregister-targets --target-group-arn $(TARGET_ARN) --targets Id=$(INSTANCE_ID_1) Id=$(INSTANCE_ID_2) Id=$(INSTANCE_ID_3) Id=$(INSTANCE_ID_4)


# Register instances for cluster 1
target_register_cluster1 :
	$(MAKE) target_register INSTANCE_ID_1=$(M4_INSTANCE_1_ID) INSTANCE_ID_2=$(M4_INSTANCE_2_ID) INSTANCE_ID_3=$(M4_INSTANCE_3_ID) INSTANCE_ID_4=$(M4_INSTANCE_4_ID)

# Register instances for cluster 2
target_register_cluster2 :
	$(MAKE) target_register INSTANCE_ID_1=$(T2_INSTANCE_1_ID) INSTANCE_ID_2=$(T2_INSTANCE_2_ID) INSTANCE_ID_3=$(T2_INSTANCE_3_ID) INSTANCE_ID_4=$(T2_INSTANCE_4_ID)

# Register instances for cluster 1
target_deregister_cluster1 :
	$(MAKE) target_deregister INSTANCE_ID_1=$(M4_INSTANCE_1_ID) INSTANCE_ID_2=$(M4_INSTANCE_2_ID) INSTANCE_ID_3=$(M4_INSTANCE_3_ID) INSTANCE_ID_4=$(M4_INSTANCE_4_ID)

# Register instances for cluster 2
target_deregister_cluster2 :
	$(MAKE) target_deregister INSTANCE_ID_1=$(T2_INSTANCE_1_ID) INSTANCE_ID_2=$(T2_INSTANCE_2_ID) INSTANCE_ID_3=$(T2_INSTANCE_3_ID) INSTANCE_ID_4=$(T2_INSTANCE_4_ID)




check_running_instances_general:
	@echo $(shell ${PATH_TO_SCRIPT})

check_target_healthy_general:
	@echo $(shell ${PATH_TO_TARGET_RUNNING} $(TARGET_ARN))


stop_cluster1:
	$(MAKE) target_deregister_cluster1
	$(MAKE) stop_cluster1_instances

setup_cluster1:
	$(MAKE) start_cluster1_instances
	$(MAKE) check_running_instances_general PATH_TO_SCRIPT=$(PATH_TO_SCRIPT_RUNNING_1)
	$(MAKE) target_register_cluster1
	$(MAKE) check_target_healthy_general


stop_cluster2:
	$(MAKE) target_deregister_cluster2
	$(MAKE) stop_cluster2_instances

setup_cluster2:
	$(MAKE) start_cluster2_instances
	$(MAKE) check_running_instances_general PATH_TO_SCRIPT=$(PATH_TO_SCRIPT_RUNNING_2)
	$(MAKE) target_register_cluster2
	$(MAKE) check_target_healthy_general



collect_metric:
	aws cloudwatch get-metric-statistics --metric-name METRIC --start-time $(START_TIME) --end-time $(END_TIME) --period 900 --statistics Average --namespace AWS/ELB --dimensions Name=LoadBalancerName,Value=$(ELB_URL)


collect_example:
	$(MAKE) collect_metric METRIC=Requests


requests:
	python3 -m $(PATH_TO_PYTHON_SCRIPT) run_scenario --url=$(ELB_NAME)


scenario1:
	$(MAKE) setup_cluster1
	$(MAKE) requests
	$(MAKE) stop_cluster1

scenario2:
	$(MAKE) setup_cluster2
	$(MAKE) requests
	$(MAKE) stop_cluster2


test:
	$(shell './scripts/setup_instances.sh')



#value=$(call check_status);\
#	echo $(value)
#	$(call check_ok, $(value)  )
#$(call check_ok,  $$(eval $$(call check_status)) )


#define check_ok
#	echo "INPUT OF FUNCTION : $(1)";\
#	if [ $(1) == "TEST" ] ; then \
#  		echo "YOU WIN";\
#  	else \
#  	  echo "YOU LOOSE";\
#  	fi
#endef

#aws ec2 describe-instances | jq '.Reservations[] | select(.Instances[].SecurityGroups[].GroupName=="cluster1-sg") | .Instances[] .State .Name' |  sort | uniq -c  | awk '{print $$1}');

#define check_status
#	while true ; \
#	target_status=$(shell aws ec2 describe-instances --filters Name=instance.group-id,Values=${SECURITY_GROUP_NAME_CLUSTER1} --query 'Reservations[*].Instances[*].State.[Name]'  --output text |  grep stopped | sort | uniq -c | awk '{print $$1}'  ) ; \
#	if [$${target_status} != 4 ] ; then \
#		echo "Number of running instances $${target_status}" ;\
#		sleep 1;\
#	else \
#		echo "All the instances are running" ; \
#		break \
#	fi
#endef
##	echo "$${target_status}"
#




#	if [ $${target_status} == 0 ] ; then \
#		echo "TEST";\
#	else \
#		echo "BAD TEST";\
#	fi

#	if [ $${target_status} == 4 ] ; then \
#		echo "TEST";\
#	else \
#		echo "BAD TEST";\
#	fi


all_scenario:
	$(shell ./script)

#help :


#aws cloudwatch get-metric-statistics --namespace AWS/ApplicationELB --metric-name UnHealthyHostCount --statistics Average  --period 3600 --dimensions Name=LoadBalancer,Value=app/my-load-balancer/50dc6c495c0c9188 Name=TargetGroup,Value=targetgroup/my-targets/73e2d6bc24d8a067 --start-time 2016-04-18T00:00:00Z --end-time 2016-04-21T00:00:00Z
