# TP 2 


## Setup 

First of all, one should change the `RESSOURCE_GROUP` and `NAME` in `configs/setup_vm.sh` to be able to start VM inside the image. 
Make sure to make the key to connect to Azure account the a folder `credentials`, and name it `log_key.cer`. 



To start the docker, use this command :

```
make docker_start
```

It will start the docker 

## Hadoop vs Linux 

To launch the scenario, one should launch the following command : 
```shell
make hadoop_vs_linux
```
Once the script has finished, we can get the results to local in order to plot them.
To do so, use (in local) : 

```shell
make copy_results_to_local
```

Please note that this command can be done after having the results for Hadoop vs spark. 

## Launch the VM

To log to Azure, start the VM, send files to it and connect with SSH inside, use : 

```shell
make azure
```

It will ask to go in a URL with a given code. Do so. 

## Hadoop vs Spark

To run the script to get the results for Hadoop and Spark, use : 
```shell
make hadoop_vs_spark
```

Then, exit the VM with `exit`. 

To get the results into the Docker VM and stop the VM, use : 
```shell
make close_vm
```

Then, use the commands to get back the results in local : 

```shell
make copy_results_to_local
```

## Plot results 

# TO DO 


## Recommandation 

# TO DO 