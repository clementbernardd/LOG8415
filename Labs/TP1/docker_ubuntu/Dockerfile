FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade && 	apt-get -y install make python3-pip && pip install awscli requests fire && mkdir root/scripts root/python
COPY scripts root/scripts/
COPY python root/python
COPY metrics root/
WORKDIR /root
