FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade && 	apt-get -y install make python3-pip && pip install awscli requests fire numpy pandas matplotlib && mkdir -p root/scripts root/python root/metrics/available_metrics root/metrics/results/elb root/metrics/results/instances root/metrics/results/figures
COPY scripts root/scripts/
COPY python root/python
COPY script.sh root/
WORKDIR /root
