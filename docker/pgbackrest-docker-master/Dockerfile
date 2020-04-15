FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which  openssl-devel perl-ExtUtils-Embed perl-libs "perl(:MODULE_COMPAT_5.10.1)" perl-DBD-Pg perl-Digest-SHA  perl-IO-Socket-SSL perl-JSON perl-Time-HiRes perl-XML-LibXML perl-parent #libxml2-devel
#RUN yum install -y net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which  openssl-devel perl-ExtUtils-Embed perl-libs "perl(:MODULE_COMPAT_5.16.3)" perl-DBD-Pg perl-Digest-SHA  perl-IO-Socket-SSL perl-JSON-PP perl-Time-HiRes perl-XML-LibXML #libxml2-devel

#USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens
USER agens

#AGENSGRAPH
USER agens
WORKDIR /home/agens
RUN git clone http://github.com/bitnine-oss/agensgraph.git
ENV AGHOME=/home/agens/agensgraph
WORKDIR $AGHOME
RUN $AGHOME/configure --prefix=$AGHOME
RUN make
RUN make install
ENV PATH=$AGHOME/bin:$PATH
ENV LD_LIBRARY_PATH=$AGHOME/lib:$LD_LIBRARY_PATH

#pgbackrest v2.06
USER agens
WORKDIR /home/agens
RUN rm -rf pgbackrest
RUN git clone http://github.com/pgbackrest/pgbackrest.git
ENV PBHOME=/home/agens/pgbackrest
ENV PBHOME_2_06=/home/agens/pgbackrest_2_06
WORKDIR $PBHOME
RUN git checkout -b 2.06 release/2.06
RUN make -C "$PBHOME/src"
RUN mkdir -p $PBHOME_2_06
RUN cp $PBHOME/src/pgbackrest $PBHOME_2_06

RUN mkdir -p $PBHOME_2_06/log
RUN mkdir -p $PBHOME_2_06/repo

RUN mkdir -p $PBHOME_2_06/data
RUN chmod 700 $PBHOME_2_06/data
ENV PBHOME_2_06_AGDATA=$PBHOME_2_06/data
RUN initdb -D $PBHOME_2_06_AGDATA


USER root
COPY 2.06/pgbackrest.conf $PBHOME_2_06
RUN chown agens:agens $PBHOME_2_06/pgbackrest.conf
COPY 2.06/postgresql.conf $PBHOME_2_06_AGDATA
RUN chown agens:agens $PBHOME_2_06_AGDATA/postgresql.conf

#pgbackrest v1.29
USER agens
WORKDIR /home/agens
RUN rm -rf pgbackrest
RUN git clone http://github.com/pgbackrest/pgbackrest.git
ENV PBHOME=/home/agens/pgbackrest
ENV PBHOME_1_29=/home/agens/pgbackrest_1_29
WORKDIR $PBHOME
RUN git checkout -b 1.29 release/1.29
RUN mkdir -p $PBHOME_1_29
RUN cp -r $PBHOME/* $PBHOME_1_29

RUN mkdir -p $PBHOME_1_29/log
RUN mkdir -p $PBHOME_1_29/repo

RUN mkdir -p $PBHOME_1_29/data
RUN chmod 700 $PBHOME_1_29/data
ENV PBHOME_1_29_AGDATA=$PBHOME_1_29/data
RUN initdb -D $PBHOME_1_29_AGDATA

USER root
COPY 1.29/pgbackrest.conf $PBHOME_1_29
RUN chown agens:agens $PBHOME_1_29/pgbackrest.conf
COPY 1.29/postgresql.conf $PBHOME_1_29_AGDATA
RUN chown agens:agens $PBHOME_1_29_AGDATA/postgresql.conf

#pgbackrest master
USER agens
WORKDIR /home/agens
RUN rm -rf pgbackrest
RUN git clone http://github.com/pgbackrest/pgbackrest.git
ENV PBHOME=/home/agens/pgbackrest
ENV PBHOME_MASTER=/home/agens/pgbackrest_master
WORKDIR $PBHOME
RUN make -C "$PBHOME/src"
RUN mkdir -p $PBHOME_MASTER
RUN cp $PBHOME/src/pgbackrest $PBHOME_MASTER

RUN mkdir -p $PBHOME_MASTER/log
RUN mkdir -p $PBHOME_MASTER/repo

RUN mkdir -p $PBHOME_MASTER/data
RUN chmod 700 $PBHOME_MASTER/data
ENV PBHOME_MASTER_AGDATA=$PBHOME_MASTER/data
RUN initdb -D $PBHOME_MASTER_AGDATA


USER root
COPY pgbackrest.conf $PBHOME_MASTER
RUN chown agens:agens $PBHOME_MASTER/pgbackrest.conf
COPY postgresql.conf $PBHOME_MASTER_AGDATA
RUN chown agens:agens $PBHOME_MASTER_AGDATA/postgresql.conf


USER root
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh


#TEST
USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
