FROM centos:7

USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y java-1.8.0-openjdk-devel.x86_64 openssh-server openssh-clients openssh-askpass net-tools wget gcc glibc glib-common readline readline-devel zlib zlib-devel flex bison git make nc which

#USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens
USER agens
WORKDIR /home/agens

#SSH
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 644 ~/.ssh/authorized_keys

#JAVA
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64
ENV LDFLAGS="-L/$JAVA_HOME/jre/lib/amd64/server/"

#AGENSGRAPH
ARG AG_VERSION=2.0.0
ENV AG_VER=${AG_VERSION}
RUN git clone https://github.com/bitnine-oss/agensgraph.git
ENV AGHOME=/home/agens/agensgraph
WORKDIR $AGHOME
RUN git --git-dir=$AGHOME/.git checkout tags/v$AG_VER
RUN $AGHOME/configure --prefix=$AGHOME
RUN make
RUN make install
RUN make install-world
ENV PATH=$AGHOME/bin:$PATH
ENV LD_LIBRARY_PATH=$AGHOME/lib:$LD_LIBRARY_PATH

RUN mkdir -p $AGHOME/data
RUN chmod 700 $AGHOME/data
ENV AGDATA=$AGHOME/data

#HADOOP
WORKDIR /home/agens
ARG HADOOP_VERSION=3.1.1
ENV HADOOP_VER=$HADOOP_VERSION
RUN wget http://mirror.apache-kr.org/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz
RUN tar -xvf hadoop-$HADOOP_VER.tar.gz
RUN rm -rf hadoop-$HADOOP_VER.tar.gz
RUN cp -rp hadoop-$HADOOP_VER hadoop
RUN rm -rf hadoop-$HADOOP_VER
ENV HADOOP_HOME=/home/agens/hadoop
ENV HADOOP_CONFIG_HOME=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/bin:$PATH
ENV PATH=$HADOOP_HOME/sbin:$PATH

COPY hadoop/hadoop-env.sh $HADOOP_CONFIG_HOME/hadoop-env.sh
COPY hadoop/core-site.xml $HADOOP_CONFIG_HOME/core-site.xml
COPY hadoop/hdfs-site.xml $HADOOP_CONFIG_HOME/hdfs-site.xml
COPY hadoop/mapred-site.xml $HADOOP_CONFIG_HOME/mapred-site.xml
COPY hadoop/yarn-site.xml $HADOOP_CONFIG_HOME/yarn-site.xml

RUN mkdir -p $HADOOP_HOME/logs

#HIVE
ARG HIVE_VERSION=3.1.0
ENV HIVE_VER=${HIVE_VERSION}
RUN wget http://mirror.apache-kr.org/hive/hive-$HIVE_VER/apache-hive-$HIVE_VER-bin.tar.gz
RUN tar -xvf apache-hive-$HIVE_VER-bin.tar.gz
RUN rm -rf apache-hive-$HIVE_VER-bin.tar.gz
RUN cp -rp apache-hive-$HIVE_VER-bin hive
RUN rm -rf apache-hive-$HIVE_VER-bin
ENV HIVE_HOME=/home/agens/hive
ENV PATH=$HIVE_HOME/bin:$PATH
ENV CLASSPATH=$CLASSPATH:$HIVE_HOME/lib/*:.

COPY hive/conf/hive-env.sh $HIVE_HOME/conf/hive-env.sh
COPY hive/conf/hive-site.xml $HIVE_HOME/conf/hive-site.xml


ARG AG_JDBC_VERSION=1.4.2
ENV AG_JDBC_VER=${AG_JDBC_VERSION}
RUN wget http://central.maven.org/maven2/net/bitnine/agensgraph-jdbc/$AG_JDBC_VER/agensgraph-jdbc-$AG_JDBC_VER.jar -O $HIVE_HOME/lib/agensgraph-jdbc-$AG_JDBC_VER.jar

#HADOOP_FDW
RUN mkdir /home/agens/agensgraph-enterprise 
ENV AG_EE_HOME=/home/agens/agensgraph-enterprise
WORKDIR $AG_EE_HOME
RUN git init
RUN git pull https://bylee5:a1530810@github.com/bitnine-oss/agensgraph-enterprise.git pull/4/head:feat_support_hadoop_fdw_beta1
RUN cp -r contrib/hadoop_fdw $AGHOME/contrib

WORKDIR $AGHOME/contrib/hadoop_fdw
RUN USE_PGXS=1 make
RUN USE_PGXS=1 make install

WORKDIR $AGHOME/lib/postgresql
RUN jar cvf Hadoop_FDW.jar HadoopJDBCLoader.class HadoopJDBCUtils.class

WORKDIR $AGHOME/lib
RUN ln -s $JAVA_HOME/jre/lib/amd64/server/libjvm.so libjvm.so
RUN cp $HIVE_HOME/jdbc/hive-jdbc-$HIVE_VER-standalone.jar  $AGHOME/lib/postgresql
RUN cp $HADOOP_HOME/share/hadoop/common/hadoop-common-$HADOOP_VER.jar $AGHOME/lib/postgresql

ENV HADOOP_FDW_CLASSPATH=$AGHOME/lib/postgresql/hive-jdbc-$HIVE_VER-standalone.jar:$AGHOME/lib/postgresql/hadoop-common-$HADOOP_VER.jar:$AGHOME/lib/postgresql/Hadoop_FDW.jar
WORKDIR /home/agens


COPY startup.sh /home/agens/startup.sh

USER root
ENTRYPOINT ["/home/agens/startup.sh"]
