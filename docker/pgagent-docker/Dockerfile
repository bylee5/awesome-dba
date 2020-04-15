FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y net-tools wget git make which 

#YUM INSTALL with AGENSGRAPH
RUN yum install -y gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison

#YUM INSTALL with PGAGENT
RUN yum install -y epel-release
RUN yum install -y cmake3 boost-devel

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

#PGAGENT
WORKDIR $AGHOME/contrib
RUN git clone http://github.com/postgres/pgagent.git
ENV PAHOME=$AGHOME/contrib/pgagent
WORKDIR $PAHOME
RUN cmake3  -D BOOST_ROOT:PATH=/usr/lib64 \
        	-D BOOST_STATIC_BUILD:BOOL=OFF \
        	-D CMAKE_INSTALL_PREFIX:PATH=$HOME \
	    	-D PG_CONFIG_PATH:FILEPATH=$AGHOME/bin/pg_config \
	    	-D STATIC_BUILD:BOOL=OFF .
RUN make USE_PGXS=1
RUN make USE_PGXS=1 install
ENV PATH=$HOME:$PATH

USER root
COPY sql/cypher.sql $PAHOME/test/sql/cypher.sql
RUN chown agens:agens $PAHOME/test/sql/cypher.sql
COPY expected/cypher.out $PAHOME/test/expected/cypher.out
RUN chown agens:agens $PAHOME/test/expected/cypher.out

#TEST
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh

USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]

