FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which libevent-devel openssl-devel pkgconfig libtool python-docutils

#USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens
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

#PGBOUNCER master
WORKDIR /home/agens
RUN wget https://github.com/jgm/pandoc/releases/download/2.6/pandoc-2.6-linux.tar.gz
RUN tar xvf pandoc-2.6-linux.tar.gz
ENV PATH=/home/agens/pandoc-2.6/bin:$PATH
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_MASTER=/home/agens/pgbouncer_master
WORKDIR $PBHOME
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_MASTER
RUN make
RUN make install

USER root
COPY pgbouncer.ini $PBHOME_MASTER
RUN chown agens:agens $PBHOME_MASTER/pgbouncer.ini
COPY users.txt $PBHOME_MASTER
RUN chown agens:agens $PBHOME_MASTER/users.txt

#PGBOUNCER v1.5
USER agens
WORKDIR /home/agens
RUN rm -rf pgbouncer
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_1_5=/home/agens/pgbouncer_1_5
WORKDIR $PBHOME
RUN git checkout -b 1.5 pgbouncer_1_5
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_1_5
RUN make
RUN make install

USER root
COPY 1.5/pgbouncer.ini $PBHOME_1_5
RUN chown agens:agens $PBHOME_1_5/pgbouncer.ini
COPY 1.5/users.txt $PBHOME_1_5
RUN chown agens:agens $PBHOME_1_5/users.txt

#PGBOUNCER v1.6
USER agens
WORKDIR /home/agens
RUN rm -rf pgbouncer
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_1_6=/home/agens/pgbouncer_1_6
WORKDIR $PBHOME
RUN git checkout -b 1.6 pgbouncer_1_6
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_1_6
RUN make
RUN make install

USER root
COPY 1.6/pgbouncer.ini $PBHOME_1_6
RUN chown agens:agens $PBHOME_1_6/pgbouncer.ini
COPY 1.6/users.txt $PBHOME_1_6
RUN chown agens:agens $PBHOME_1_6/users.txt


#PGBOUNCER v1.7
USER agens
WORKDIR /home/agens
RUN rm -rf pgbouncer
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_1_7=/home/agens/pgbouncer_1_7
WORKDIR $PBHOME
RUN git checkout -b 1.7 pgbouncer_1_7
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_1_7
RUN make
RUN make install

USER root
COPY 1.7/pgbouncer.ini $PBHOME_1_7
RUN chown agens:agens $PBHOME_1_7/pgbouncer.ini
COPY 1.7/users.txt $PBHOME_1_7
RUN chown agens:agens $PBHOME_1_7/users.txt


#PGBOUNCER v1.8
USER agens
WORKDIR /home/agens
RUN rm -rf pgbouncer
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_1_8=/home/agens/pgbouncer_1_8
WORKDIR $PBHOME
RUN git checkout -b 1.8 pgbouncer_1_8
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_1_8
RUN make
RUN make install

USER root
COPY 1.8/pgbouncer.ini $PBHOME_1_8
RUN chown agens:agens $PBHOME_1_8/pgbouncer.ini
COPY 1.8/users.txt $PBHOME_1_8
RUN chown agens:agens $PBHOME_1_8/users.txt


#PGBOUNCER v1.9
USER agens
WORKDIR /home/agens
RUN rm -rf pgbouncer
RUN git clone http://github.com/pgbouncer/pgbouncer.git
ENV PBHOME=/home/agens/pgbouncer
ENV PBHOME_1_9=/home/agens/pgbouncer_1_9
WORKDIR $PBHOME
RUN git checkout -b 1.9 pgbouncer_1_9_0
RUN git submodule init
RUN git submodule update
RUN ./autogen.sh
RUN $PBHOME/configure --prefix=$PBHOME_1_9
RUN make
RUN make install

USER root
COPY 1.9/pgbouncer.ini $PBHOME_1_9
RUN chown agens:agens $PBHOME_1_9/pgbouncer.ini
COPY 1.9/users.txt $PBHOME_1_9
RUN chown agens:agens $PBHOME_1_9/users.txt


USER root
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh


#TEST
USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
