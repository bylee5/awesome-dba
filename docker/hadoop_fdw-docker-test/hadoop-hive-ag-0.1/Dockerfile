FROM centos:7

USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y java-1.8.0-openjdk-devel.x86_64 openssh-server openssh-clients openssh-askpass net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which

#USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens
USER agens
WORKDIR /home/agens

#SSH
RUN ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 644 ~/.ssh/authorized_keys
USER root
ADD ssh_config /home/agens/.ssh/config
RUN chmod 600 /home/agens/.ssh/config; \
    chown agens:agens /home/agens/.ssh/config
USER agens

#JAVA
RUN ln -svT "/usr/lib/jvm/$(rpm -qa | grep java-1.8.0-openjdk-1.8.0)" /home/agens/docker-java-home
ENV JAVA_HOME /home/agens/docker-java-home
ENV LDFLAGS="-L/$JAVA_HOME/jre/lib/amd64/server/"

#AGENSGRAPH
RUN set -e
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
ENV HADOOP_USER_CLASSPATH_FIRST=true

COPY hive/conf/hive-env.sh $HIVE_HOME/conf/hive-env.sh
COPY hive/conf/hive-site.xml $HIVE_HOME/conf/hive-site.xml


ARG AG_JDBC_VERSION=1.4.2
ENV AG_JDBC_VER=${AG_JDBC_VERSION}
RUN wget http://central.maven.org/maven2/net/bitnine/agensgraph-jdbc/$AG_JDBC_VER/agensgraph-jdbc-$AG_JDBC_VER.jar -O $HIVE_HOME/lib/agensgraph-jdbc-$AG_JDBC_VER.jar

#HADOOP_FDW
WORKDIR /home/agens
RUN git clone https://<ID>:<PW>@github.com/bitnine-oss/agensgraph-enterprise.git
RUN cp -r agensgraph-enterprise/contrib/hadoop_fdw $AGHOME/contrib

WORKDIR $AGHOME/contrib/hadoop_fdw
RUN USE_PGXS=1 make
RUN USE_PGXS=1 make install

WORKDIR $AGHOME/lib/postgresql
RUN jar cvf Hadoop_FDW.jar HadoopJDBCLoader.class HadoopJDBCUtils.class

WORKDIR $AGHOME/lib
RUN ln -s $JAVA_HOME/jre/lib/amd64/server/libjvm.so libjvm.so
RUN cp $HIVE_HOME/jdbc/hive-jdbc-$HIVE_VER-standalone.jar  $AGHOME/lib/postgresql 2>/dev/null || :
RUN cp $HIVE_HOME/lib/hive-jdbc-$HIVE_VER-standalone.jar  $AGHOME/lib/postgresql 2>/dev/null || :
RUN cp $HADOOP_HOME/share/hadoop/common/hadoop-common-$HADOOP_VER.jar $AGHOME/lib/postgresql

ENV HADOOP_FDW_CLASSPATH=$AGHOME/lib/postgresql/hive-jdbc-$HIVE_VER-standalone.jar:$AGHOME/lib/postgresql/hadoop-common-$HADOOP_VER.jar:$AGHOME/lib/postgresql/Hadoop_FDW.jar
WORKDIR /home/agens


COPY startup.sh /home/agens/startup.sh

USER root
ENTRYPOINT ["/home/agens/startup.sh"]
