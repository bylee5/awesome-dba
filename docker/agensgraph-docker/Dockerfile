FROM centos:latest

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

USER root
COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh


#TEST
USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
