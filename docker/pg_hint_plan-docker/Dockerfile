FROM centos:6.8

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL
RUN yum install -y net-tools wget git make which

#YUM INSTALL with AGENSGRAPH
RUN yum install -y gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison

#YUM INSTALL with PG_HINT_PLAN
RUN yum install -y patch

#USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens
USER agens

#AGENSGRAPH
WORKDIR /home/agens
RUN git clone http://github.com/bitnine-oss/agensgraph.git
ENV AGHOME=/home/agens/agensgraph
WORKDIR $AGHOME
RUN $AGHOME/configure --prefix=$AGHOME
RUN make world
RUN make install-world
ENV PATH=$AGHOME/bin:$PATH
ENV LD_LIBRARY_PATH=$AGHOME/lib:$LD_LIBRARY_PATH

RUN mkdir -p $AGHOME/data
RUN chmod 700 $AGHOME/data
ENV AGDATA=$AGHOME/data

#PG_HINT_PLAN
WORKDIR $AGHOME/contrib
RUN git clone http://github.com/ossc-db/pg_hint_plan.git
ENV PHPHOME=$AGHOME/contrib/pg_hint_plan
WORKDIR $PHPHOME
RUN git checkout REL10_1_3_3

USER root
COPY patch/core.c.patch $PHPHOME/
RUN chown agens:agens $PHPHOME/core.c.patch
COPY patch/make_join_rel.c.patch $PHPHOME/
RUN chown agens:agens $PHPHOME/make_join_rel.c.patch

USER agens
RUN patch core.c core.c.patch
RUN patch make_join_rel.c make_join_rel.c.patch
RUN make
RUN make USE_PGXS=1 install

USER root
COPY expected/cypher.out $PHPHOME/expected/
RUN chown agens:agens $PHPHOME/expected/cypher.out
COPY sql/cypher.sql $PHPHOME/sql/
RUN chown agens:agens $PHPHOME/sql/cypher.sql

COPY expected/init.out $PHPHOME/expected/
RUN chown agens:agens $PHPHOME/expected/init.out
COPY expected/pg_hint_plan.out $PHPHOME/expected/
RUN chown agens:agens $PHPHOME/expected/pg_hint_plan.out
COPY expected/ut-A.out $PHPHOME/expected/
RUN chown agens:agens $PHPHOME/expected/ut-A.out
COPY expected/ut-S.out $PHPHOME/expected/
RUN chown agens:agens $PHPHOME/expected/ut-S.out

COPY output/ut-W.source $PHPHOME/output/
RUN chown agens:agens $PHPHOME/output/ut-W.source

#TEST
USER root
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh

USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
