FROM centos:latest

#ROOT PASSWD
USER root
RUN echo "root:root" | chpasswd
WORKDIR /root

#YUM INSTALL with AgensGraph
RUN yum install -y net-tools wget gcc gcc-c++ glibc glib-common readline readline-devel zlib zlib-devel flex bison git make which 

# YUM INSTALL with AgensBrowser
RUN yum install -y java-1.8.0-openjdk-devel.x86_64 unzip

#YUM INSTALL with pgbouncer
RUN yum install -y libevent-devel libtool openssl-devel python-docutils

#YUM INSTALL with pgbackrest
RUN yum install -y openssl-devel perl-ExtUtils-Embed perl-libs "perl(:MODULE_COMPAT_5.10.1)" perl-DBD-Pg perl-Digest-SHA  perl-IO-Socket-SSL perl-JSON perl-Time-HiRes perl-XML-LibXML perl-parent libxml2-devel perl-JSON-PP

#YUM INSTALL with pgaudit
RUN yum install -y openssl-devel

#YUM INSTALL with pgagent
RUN yum install -y epel-release
RUN yum install -y cmake3 boost-devel

#CREATE USER
RUN useradd -m -c "AgensGraph User" -U agens -p agens

# AgensGraph
RUN mkdir -p /home/agens/AgensGraph_v2.1.2
RUN chown agens:agens /home/agens/AgensGraph_v2.1.2
COPY AgensGraph_v2.1.2/AgensGraph_v2.1.2_linux_CE.tar.gz /home/agens/AgensGraph_v2.1.2/AgensGraph_v2.1.2_linux_CE.tar.gz
RUN chown agens:agens /home/agens/AgensGraph_v2.1.2/AgensGraph_v2.1.2_linux_CE.tar.gz
COPY AgensGraph_v2.1.2/AgensGraph-2.1.2-linux-installer.sh /home/agens/AgensGraph_v2.1.2/AgensGraph-2.1.2-linux-installer.sh
RUN chown agens:agens /home/agens/AgensGraph_v2.1.2/AgensGraph-2.1.2-linux-installer.sh

# AgensBrowser
RUN mkdir -p /home/agens/AgensBrowser_v1.1
RUN chown agens:agens /home/agens/AgensBrowser_v1.1
COPY AgensBrowser_v1.1/agens-browser-web-1.1.zip /home/agens/AgensBrowser_v1.1/agens-browser-web-1.1.zip
RUN chown agens:agens /home/agens/AgensBrowser_v1.1/agens-browser-web-1.1.zip
COPY AgensBrowser_v1.1/AgensBrowser-1.1-installer.sh /home/agens/AgensBrowser_v1.1/AgensBrowser-1.1-installer.sh
RUN chown agens:agens /home/agens/AgensBrowser_v1.1/AgensBrowser-1.1-installer.sh

# backup
RUN mkdir -p /home/agens/pgBackRest_v2.05
RUN chown agens:agens /home/agens/pgBackRest_v2.05
COPY pgBackRest_v2.05/2.05.tar.gz /home/agens/pgBackRest_v2.05/2.05.tar.gz
RUN chown agens:agens /home/agens/pgBackRest_v2.05/2.05.tar.gz
COPY pgBackRest_v2.05/pgBackRest-2.05-installer.sh /home/agens/pgBackRest_v2.05/pgBackRest-2.05-installer.sh
RUN chown agens:agens /home/agens/pgBackRest_v2.05/pgBackRest-2.05-installer.sh

# HA
RUN mkdir -p /home/agens/stolon_v0.12.0
RUN chown agens:agens /home/agens/stolon_v0.12.0
COPY stolon_v0.12.0/etcd-v3.3.9-linux-amd64.tar.gz /home/agens/stolon_v0.12.0/etcd-v3.3.9-linux-amd64.tar.gz
RUN chown agens:agens /home/agens/stolon_v0.12.0/etcd-v3.3.9-linux-amd64.tar.gz
COPY stolon_v0.12.0/stolon-v0.12.0-linux-amd64.tar.gz /home/agens/stolon_v0.12.0/stolon-v0.12.0-linux-amd64.tar.gz
RUN chown agens:agens /home/agens/stolon_v0.12.0/stolon-v0.12.0-linux-amd64.tar.gz
COPY stolon_v0.12.0/stolon-0.12.0-installer.sh /home/agens/stolon_v0.12.0/stolon-0.12.0-installer.sh
RUN chown agens:agens /home/agens/stolon_v0.12.0/stolon-0.12.0-installer.sh

# connection pool
RUN mkdir -p /home/agens/pgbouncer_v1.9.0
RUN chown agens:agens /home/agens/pgbouncer_v1.9.0
COPY pgbouncer_v1.9.0/pgbouncer-1.9.0.tar.gz /home/agens/pgbouncer_v1.9.0/pgbouncer-1.9.0.tar.gz
RUN chown agens:agens /home/agens/pgbouncer_v1.9.0/pgbouncer-1.9.0.tar.gz
COPY pgbouncer_v1.9.0/pgbouncer-1.9.0-installer.sh /home/agens/pgbouncer_v1.9.0/pgbouncer-1.9.0-installer.sh
RUN chown agens:agens /home/agens/pgbouncer_v1.9.0/pgbouncer-1.9.0-installer.sh

# audit
RUN mkdir -p /home/agens/pgaudit_v1.2.1
RUN chown agens:agens /home/agens/pgaudit_v1.2.1
COPY pgaudit_v1.2.1/pgaudit-1.2.1.tar.gz /home/agens/pgaudit_v1.2.1/pgaudit-1.2.1.tar.gz
RUN chown agens:agens /home/agens/pgaudit_v1.2.1/pgaudit-1.2.1.tar.gz
COPY pgaudit_v1.2.1/pgaudit-1.2.1-installer.sh /home/agens/pgaudit_v1.2.1/pgaudit-1.2.1-installer.sh
RUN chown agens:agens /home/agens/pgaudit_v1.2.1/pgaudit-1.2.1-installer.sh

# job scheduler
RUN mkdir -p /home/agens/pgagent_v4.0.0
RUN chown agens:agens /home/agens/pgagent_v4.0.0
COPY pgagent_v4.0.0/pgagent-REL-4_0_0.tar.gz /home/agens/pgagent_v4.0.0/pgagent-REL-4_0_0.tar.gz
RUN chown agens:agens /home/agens/pgagent_v4.0.0/pgagent-REL-4_0_0.tar.gz
COPY pgagent_v4.0.0/pgagent-4.0.0-installer.sh /home/agens/pgagent_v4.0.0/pgagent-4.0.0-installer.sh
RUN chown agens:agens /home/agens/pgagent_v4.0.0/pgagent-4.0.0-installer.sh

# hint plan
RUN mkdir -p /home/agens/pg_hint_plan_v1.3.3
RUN chown agens:agens /home/agens/pg_hint_plan_v1.3.3
COPY pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3.tar.gz /home/agens/pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3.tar.gz
RUN chown agens:agens /home/agens/pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3.tar.gz
COPY pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3-installer.sh /home/agens/pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3-installer.sh
RUN chown agens:agens /home/agens/pg_hint_plan_v1.3.3/pg_hint_plan-1.3.3-installer.sh

COPY install-2.sh /home/agens/install-2.sh
RUN chown agens:agens /home/agens/install-2.sh

COPY startup.sh /home/agens/startup.sh
RUN chown agens:agens /home/agens/startup.sh

#TEST
USER agens
WORKDIR /home/agens
ENTRYPOINT ["/home/agens/startup.sh"]
