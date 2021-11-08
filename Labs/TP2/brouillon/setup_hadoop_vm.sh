#!/bin/bash

export HADOOP_PREFIX=/usr/local/hadoop-2.10.1
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

function add_env_variables(){
  echo "export HADOOP_PREFIX=/usr/local/hadoop-2.10.1" >> ~/.profile ;
  echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ~/.profile ;
  source ~/.profile ;
}

function install_packages(){
  apt-get update ;
  apt-get install -y  ssh rsync vim default-jre-headless openssh-server time ;
  wget https://dlcdn.apache.org/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz && \
  tar -xf hadoop-2.10.1.tar.gz -C /usr/local/ && \
	echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin" >> ~/.bashrc  && \
	echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh ;
}

function init_ssh(){
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa;
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys ;
  chmod 0600 ~/.ssh/authorized_keys ;
  sudo /etc/init.d/ssh start ;
}

function set_hadoop(){
  mv ./configs/*xml $HADOOP_PREFIX/etc/hadoop/ ;
}

#add_env_variables;
#install_packages ;
#init_ssh ;
#set_hadoop ;

