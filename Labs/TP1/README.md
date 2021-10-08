# TP1 guide 

This TP is an introduction to the AWS system. The aim was to send HTTP requests to two different clusters with different EC2 instances through an Elastic Load Balancer.


## Docker build 

To build the docker, please use the following command line : 

```
cd docker_ubuntu
docker build -t <NAME> .
docker run -it -e AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id) -e AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)  -e AWS_DEFAULT_REGION=$(aws configure get region) -e AWS_SESSION_TOKEN=$(aws configure get aws_session_token)  <NAME> /bin/bash
```
One can replace the last line that runs the instance with ```./launch_docker_command.txt```. 

Please ensure to have the files in `~/.aws/` up to date. 

## Run the scenarios 

To run the scenario, one should create 4 instances of `t2.xlarge` and `m4.large`, and replace the instances in the `script.sh` file. 

Then, one should replace the security-group names of the cluster 1, cluster 2 and the elastic load balancer, in the `script.sh` file. 

Once the setup is done, just launch : 

```shell
./script.sh
```

and the rest is history. 