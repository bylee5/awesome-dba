FROM centos:7

#JAVA

USER root

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64

# Install Packages
RUN yum update -y; \
    yum install -y java-1.8.0-openjdk-devel wget unzip curl vim python-setuptools sudo; \
    easy_install supervisor
RUN yum clean all


#HADOOP
ENV HADOOP_VER 3.1.1

ENV HDFS_NAMENODE_USER "root"
ENV HDFS_DATANODE_USER "root"
ENV HDFS_SECONDARYNAMENODE_USER "root"
ENV YARN_RESOURCEMANAGER_USER "root"
ENV YARN_NODEMANAGER_USER "root"
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE $HADOOP_HOME/lib/native
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV HADOOP_LOG_DIR $HADOOP_HOME/logs

ENV PATH $HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# Install needed packages
RUN yum install -y which openssh-clients openssh-server openssl
RUN yum clean all

WORKDIR /opt/docker

RUN useradd -p $(echo "hdfs" | openssl passwd -1 -stdin) hdfs; \
    groupadd supergroup; \
    usermod -a -G supergroup hdfs;

# Apache Hadoop
RUN wget http://mirror.apache-kr.org/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz
RUN tar -xvf hadoop-$HADOOP_VER.tar.gz -C ..; \
    mv ../hadoop-$HADOOP_VER $HADOOP_HOME

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config; \
    chown root:root /root/.ssh/config

COPY hadoop $HADOOP_HOME
#RUN cat $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY ./etc /etc
RUN chmod +x $HADOOP_HOME/etc/hadoop/*.sh
RUN chmod +x $HADOOP_HOME/bin/*.sh

RUN rm -rf /hdfs; \
    mkdir -p /hdfs; \
    chown -R hdfs:hdfs /hdfs; \
    chown -R hdfs:hdfs $HADOOP_HOME

#USER hdfs
RUN mkdir -p $HADOOP_HOME/logs; \
    hdfs namenode -format

# hdfs-default.xml ports
EXPOSE 9871 9870 9820 9869 9868 9867 9866 9865 9864
# mapred-default.xml ports
EXPOSE 50030 50060 13562 10020 19888
# Yarn ports
EXPOSE 8030 8031 8032 8040 8042 8046 8047 8088 8090 8188 8190 8788 10200
#Other ports
EXPOSE 21 22



#HIVE

ENV HIVE_VER 3.1.0
ENV TEZ_VER 0.9.1

ENV HIVE_HOME /opt/hive
ENV HIVE_CONF_DIR $HIVE_HOME/conf
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop
ENV HCAT_LOG_DIR /opt/hive/logs
ENV HCAT_PID_DIR /opt/hive/logs
ENV WEBHCAT_LOG_DIR /opt/hive/logs
ENV WEBHCAT_PID_DIR /opt/hive/logs

ENV PATH $HIVE_HOME/bin:$PATH

# Install needed packages
RUN yum clean all; \
    yum update -y; \
    yum install -y postgresql; \
    yum clean all

WORKDIR /opt/docker

# Apache Hive
RUN wget http://mirror.apache-kr.org/hive/hive-$HIVE_VER/apache-hive-$HIVE_VER-bin.tar.gz
RUN tar -xvf apache-hive-$HIVE_VER-bin.tar.gz -C ..; \
    mv ../apache-hive-$HIVE_VER-bin $HIVE_HOME
RUN wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jar -O $HIVE_HOME/lib/postgresql-42.2.5.jar
RUN wget https://www.apache.org/dist/tez/$TEZ_VER/apache-tez-$TEZ_VER-bin.tar.gz; \
    tar -xvf apache-tez-$TEZ_VER-bin.tar.gz
RUN cp apache-tez-$TEZ_VER-bin/tez*.jar $HIVE_HOME/lib/; \
    rm -rf apache-tez-$TEZ_VER-bin; \
    rm -f apache-tez-$TEZ_VER-bin.tar.gz
COPY hive/ $HIVE_HOME/
COPY ./etc /etc

RUN chmod +x $HIVE_HOME/bin/*.sh

RUN useradd -p $(echo "hive" | openssl passwd -1 -stdin) hive; \
    usermod -a -G supergroup hive; \
    usermod -a -G hdfs hive;

EXPOSE 9083 10000 10002 50111

COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

CMD startup.sh

