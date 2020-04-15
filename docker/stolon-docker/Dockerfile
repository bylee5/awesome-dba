FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd

#YUM INSTALL
RUN yum install -y net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which sudo

#USER
RUN useradd -m -c "AgensGraph User" -U agens
RUN echo "agens:agens" | chpasswd
RUN echo "%agens	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers
USER agens

#AGENSGRAPH
WORKDIR /home/agens
RUN git clone http://github.com/bitnine-oss/agensgraph.git
ENV AGHOME=/home/agens/agensgraph
WORKDIR $AGHOME
RUN $AGHOME/configure --prefix=$AGHOME
RUN make
RUN make install
ENV PATH=$AGHOME/bin:$PATH
ENV LD_LIBRARY_PATH=$AGHOME/lib:$LD_LIBRARY_PATH

RUN mkdir -p $AGHOME/data
RUN chmod 700 $AGHOME/data
ENV AGDATA=$AGHOME/data

USER root
COPY pgpass.conf /home/agens/pgpass.conf
RUN chown agens:agens /home/agens/pgpass.conf
RUN chmod 0600 /home/agens/pgpass.conf
ENV PGPASSFILE=/home/agens/pgpass.conf

# GO
USER agens
WORKDIR /home/agens
RUN wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz
RUN tar xf go1.11.2.linux-amd64.tar.gz
RUN sudo mv go /usr/local/
ENV PATH=/usr/local/go/bin:$PATH

# etcd
USER agens
RUN mkdir -p /home/agens/go/src
WORKDIR /home/agens/go/src
RUN git clone http://github.com/etcd-io/etcd.git
ENV ETCD_HOME=/home/agens/go/src/etcd
RUN mkdir -p /home/agens/stolon_3_3_9
ENV ETCD_HOME_3_3_9=/home/agens/stolon_3_3_9
WORKDIR $ETCD_HOME
RUN git checkout -b 3.3.9 v3.3.9
RUN ./build
RUN cp bin/* $ETCD_HOME_3_3_9/

#stolon v0.12.0
RUN mkdir -p /home/agens/go/src/github.com/sorintlab
WORKDIR /home/agens/go/src/github.com/sorintlab
RUN git clone http://github.com/sorintlab/stolon.git
ENV STOLON_HOME=/home/agens/go/src/github.com/sorintlab/stolon
ENV STOLON_HOME_0_12_0=/home/agens/stolon_0_12_0
WORKDIR $STOLON_HOME
RUN git checkout -b 0.12 v0.12.0
RUN ./build
RUN mkdir -p $STOLON_HOME_0_12_0
RUN cp bin/* $STOLON_HOME_0_12_0/

#stolon master
WORKDIR /home/agens/go/src/github.com/sorintlab
RUN rm -rf stolon
RUN git clone http://github.com/sorintlab/stolon.git
ENV STOLON_HOME=/home/agens/go/src/github.com/sorintlab/stolon
ENV STOLON_HOME_MASTER=/home/agens/stolon_MASTER
WORKDIR $STOLON_HOME
RUN ./build
RUN mkdir -p $STOLON_HOME_MASTER
RUN cp bin/* $STOLON_HOME_MASTER/



USER root
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh


#TEST
USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
