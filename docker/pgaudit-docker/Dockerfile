FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y net-tools wget git make which 

#YUM INSTALL with AGENSGRAPH
RUN yum install -y gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison

#YUM INSTALL with PGAUDIT
RUN yum install -y openssl-devel

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

#PGAUDIT
WORKDIR $AGHOME/contrib
RUN git clone https://github.com/pgaudit/pgaudit.git
ENV PAHOME=$AGHOME/contrib/pgaudit
WORKDIR $PAHOME
RUN git checkout REL_10_STABLE
RUN make USE_PGXS=1 install

USER root
COPY expected/cypher.out $PAHOME/expected/
RUN chown agens:agens $PAHOME/expected/cypher.out
COPY sql/cypher.sql $PAHOME/sql/
RUN chown agens:agens $PAHOME/sql/cypher.sql

#TEST
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh

USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
