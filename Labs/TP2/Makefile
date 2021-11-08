# Makefile to launch the commands
SHELL := /bin/bash

hadoop_vs_linux:
	#source configs/setup_hadoop.sh && start_namenode && add_directory
	bash codes/bash/comparison_linux_hadoop.sh
#&& $(MAKE) clean_hadoop

setup_vm :
	#bash configs/setup_hadoop_vm.sh
	source configs/setup_hadoop.sh && stop_namenode && start_namenode && add_directory

hadoop_vs_spark:
	#$(MAKE) setup_vm
	source configs/setup_hadoop.sh && set_standalone
	bash codes/bash/comparison_spark_hadoop.sh
#&& $(MAKE) clean_hadoop

standalone :
	source configs/setup_hadoop.sh && set_standalone

docker_start :
	bash codes/bash/start_docker.sh

copy_results_to_local :
	docker ps | grep log8415_tp2 | awk '{print $$1}' | xargs -I {} docker cp {}:/root/results ./

copy_results_vm_to_docker :
	cat credentials/ip_address.txt | xargs -I {} scp -i credentials/log_key.cer -r azureuser@{}:/home/azureuser/results/azure/* ./results/azure/

plot_results :
#	python -m codes.python.plot_results plot_hadoop_vs_linux --path_to_output='./results/local'
	python -m codes.python.plot_results plot_hadoop_vs_spark --path_to_output='./results/azure'

start_vm:
	source configs/setup_vm.sh && start_vm

stop_vm:
	source configs/setup_vm.sh && stop_vm

connect_to_vm :
	source configs/setup_vm.sh && send_and_connect

close_vm :
	$(MAKE) copy_results_vm_to_docker
	$(MAKE) stop_vm

clean_hadoop:
	source configs/setup_hadoop.sh && stop_namenode

clean :
	rm -rf results/azure/* credentials results configs codes files *.tar *.gz *.tgz || true

azure :
	az login && $(MAKE) start_vm && $(MAKE) connect_to_vm

