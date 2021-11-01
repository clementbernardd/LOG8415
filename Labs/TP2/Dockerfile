FROM ubuntu
ENV HADOOP_PREFIX /usr/local/hadoop-2.10.1
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

RUN \
  apt-get update && apt-get install -y \
  ssh rsync vim default-jre-headless openssh-server  

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz && tar -xf hadoop-2.10.1.tar.gz -C /usr/local/ && \
	echo "export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_PREFIX/bin:$PATH" >> ~/.bashrc  && \
	echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh 
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys 
RUN /etc/init.d/ssh start


ADD configs/*xml $HADOOP_PREFIX/etc/hadoop/
ADD configs/config /root/.ssh/config 
ADD configs/*sh /root/configs/
ADD files/* /root/files/
ADD codes/* /root/codes/

WORKDIR /root
EXPOSE 50070
ENTRYPOINT service ssh restart && bash