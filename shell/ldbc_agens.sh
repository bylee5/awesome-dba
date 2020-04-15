#!/bin/bash

# INITIAL VARIABLES

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

WORK_HOME="$PWD"
CACHE_HOME="$WORK_HOME/../.cache"
if [ -z "$SKIP_LOAD" ]; then
SKIP_LOAD="TRUE"
fi
SKIP_TEST="FALSE"
GIT_BRANCH="master"
SCALE_FACTOR=1
SHARED_BUFFERS="4GB"
WORK_MEM="2GB"
RANDOM_PAGE_COST="1.0"
AGENS_PORT=5432
THREAD_COUNT=4
TIME_COMPRESSION_RATIO=0.1
OPERATION_COUNT=10000

echo -e "${GREEN}`date`${NC}"

# CHECK ENVIRONMENT

echo -e "${GREEN}Check Shell: \"bash\"${NC}"
if [ "`basename \"$SHELL\"`" != "bash" ]; then
    echo -e "${RED}Failed: Shell MUST BE \"bash\"${NC}"
    exit
fi

echo -e "${GREEN}Check Script: \"ldbc_agens.sh\"${NC}"
if [ "`basename \"$BASH_SOURCE\"`" != "ldbc_agens.sh" ]; then
    echo -e "${RED}Failed: Script File MUST BE \"ldbc_agens.sh\"${NC}"
    exit
fi

echo -e "${GREEN}Check Directory: \"ldbc_agens\"${NC}"
case `basename "$WORK_HOME"` in
    ldbc_agens*)
     ;;
    *)
     echo -e "${RED}Failed: Working Directory MUST BE START \"ldbc_agens\"${NC}"
     exit
     ;;
esac


# PARSE ARGUMENTS

for ARG in "$@"; do
    K=`echo "$ARG"|cut -d '=' -f 1`
    V=`echo "$ARG"|cut -d '=' -f 2`
    case "$K" in
        "--force-load")
          SKIP_LOAD="FALSE"
          rm -f "$WORK_HOME/scalefactor" >/dev/null 2>/dev/null
          rm -f "$WORK_HOME/gitbranch" >/dev/null 2>/dev/null
          rm -f "$WORK_HOME/agensport" >/dev/null 2>/dev/null
          ;;
        "--skip-load")
          SKIP_LOAD="TRUE"
          ;;
        "--skip-test")
          SKIP_TEST="TRUE"
          ;;
        "--git-branch")
          GIT_BRANCH="$V"
          ;;
        "--shared-buffers")
          SHARED_BUFFERS="$V"
          ;;
        "--work-mem")
          WORK_MEM="$V"
          ;;
        "--random-page-cost")
          RANDOM_PAGE_COST="$V"
          ;;
        "--agens-port")
          AGENS_PORT="$V"
          ;;
        "--thread-count")
          THREAD_COUNT="$V"
          ;;
        "--time-compression-ratio")
          TIME_COMPRESSION_RATIO="$V"
          ;;
        "--operation-count")
          OPERATION_COUNT="$V"
          ;;
        "-h"|"--help"|*)
          case "$ARG" in
            "-h"|"--help")
              echo -e -n "${GREEN}"
              ;;
            *)
              echo -e -n "${RED}"
              ;;
          esac
          echo -e "Usage: ldbc_agens.sh [--force-load]"
          echo -e "                     [--skip-load]"
          echo -e "                     [--skip-test]"
          echo -e "                     [--git-branch=master]"
          echo -e "                     [--shared-buffers=4GB]"
          echo -e "                     [--work-mem=2GB]"
          echo -e "                     [--random-page-cost=1.0]"
          echo -e "                     [--agens-port=5432]"
          echo -e "                     [--thread-count=4]"
          echo -e "                     [--time-compression-ratio=0.1]"
          echo -e "                     [--operation-count=10000]"
          echo -e -n "${NC}"
          exit
          ;;
    esac
done


# SET ENVIRONMENT VARIABLES

if [ -f "$WORK_HOME/scalefactor" ]; then
    if [ "$SKIP_LOAD" = "TRUE" ]; then
        SCALE_FACTOR=`cat "$WORK_HOME/scalefactor"`
        if [ -f "$WORK_HOME/gitbranch" ]; then
            GIT_BRANCH=`cat "$WORK_HOME/gitbranch"`
        else
            echo -e "${RED}Failed: File Not Found \"$WORK_HOME/gitbranch\"${NC}"
            exit
        fi
        if [ -f "$WORK_HOME/agensport" ]; then
            AGENS_PORT=`cat "$WORK_HOME/agensport"`
        else
            echo -e "${RED}Failed: File Not Found \"$WORK_HOME/agensport\"${NC}"
            exit
        fi
        if [ -f "$WORK_HOME/sharedbuffers" ]; then
            SHARED_BUFFERS=`cat "$WORK_HOME/sharedbuffers"`
        else
            echo -e "${RED}Failed: File Not Found \"$WORK_HOME/sharedbuffers\"${NC}"
            exit
        fi
    else
        if [ -f "$WORK_HOME/../ldbc_data/scalefactor" ]; then
            SCALE_FACTOR=`cat "$WORK_HOME/../ldbc_data/scalefactor"`
        else
            echo -e "${RED}Failed: File Not Found \"$WORK_HOME/../ldbc_data/scalefactor\"${NC}"
            exit
        fi
    fi
else
    SKIP_LOAD="FALSE"
    if [ -f "$WORK_HOME/../ldbc_data/scalefactor" ]; then
        SCALE_FACTOR=`cat "$WORK_HOME/../ldbc_data/scalefactor"`
    else
        echo -e "${RED}Failed: File Not Found \"$WORK_HOME/../ldbc_data/scalefactor\"${NC}"
        exit
    fi
fi

JDBC_JAR="agensgraph-jdbc-1.4.0.jar"
case "$GIT_BRANCH" in
    v1.1|v1.2)
     JDBC_JAR="agensgraph-jdbc-1.3.2.jar"
     ;;
esac

export MAVEN_HOME="$WORK_HOME/../ldbc_data/apache-maven-3.5.2"
export AGENS_HOME="$WORK_HOME/pgsql"
export PATH="$MAVEN_HOME/bin:$AGENS_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$AGENS_HOME/lib"
export AGDATA="$AGENS_HOME/data"
export HADOOP_CLIENT_OPTS="-Xmx1G"
export LDBC_SNB_DRIVER_HOME="$WORK_HOME/ldbc_snb_driver"
export LDBC_SNB_AGENS_GRAPH_HOME="$WORK_HOME/ldbc-snb-agens-graph"
export LDBC_SNB_DATAGEN_HOME="$WORK_HOME/../ldbc_data/ldbc_snb_datagen"
export AGENS_PORT="$AGENS_PORT"

echo -e "${GREEN}export WORK_HOME=\"$WORK_HOME\"${NC}"
echo -e "${GREEN}export CACHE_HOME=\"$CACHE_HOME\"${NC}"
echo -e "${GREEN}export MAVEN_HOME=\"$MAVEN_HOME\"${NC}"
echo -e "${GREEN}export AGENS_HOME=\"$AGENS_HOME\"${NC}"
echo -e "${GREEN}export PATH=\"$PATH\"${NC}"
echo -e "${GREEN}export LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH\"${NC}"
echo -e "${GREEN}export JDBC_JAR=\"$JDBC_JAR\"${NC}"
echo -e "${GREEN}export AGDATA=\"$AGDATA\"${NC}"
echo -e "${GREEN}export LDBC_SNB_DRIVER_HOME=\"$LDBC_SNB_DRIVER_HOME\"${NC}"
echo -e "${GREEN}export LDBC_SNB_AGENS_GRAPH_HOME=\"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
echo -e "${GREEN}export LDBC_SNB_DATAGEN_HOME=\"$LDBC_SNB_DATAGEN_HOME\"${NC}"
echo -e "${GREEN}export SKIP_LOAD=$SKIP_LOAD${NC}"
echo -e "${GREEN}export SKIP_TEST=$SKIP_TEST${NC}"
echo -e "${GREEN}export GIT_BRANCH=$GIT_BRANCH${NC}"
echo -e "${GREEN}export SCALE_FACTOR=$SCALE_FACTOR${NC}"
echo -e "${GREEN}export SHARED_BUFFERS=$SHARED_BUFFERS${NC}"
echo -e "${GREEN}export AGENS_PORT=$AGENS_PORT${NC}"
echo -e "${GREEN}export THREAD_COUNT=$THREAD_COUNT${NC}"
echo -e "${GREEN}export TIME_COMPRESSION_RATIO=$TIME_COMPRESSION_RATIO${NC}"
echo -e "${GREEN}export OPERATION_COUNT=$OPERATION_COUNT${NC}"


if [ "$SKIP_LOAD" = "FALSE" ]; then

# DOWNLOAD PACKAGES & SOURCES

for FILE in `ls`; do
if [ "$FILE" != "ldbc_agens.sh" ]; then
    echo -e "${GREEN}Remove File: \"$FILE\"${NC}"
    rm -rf "$FILE"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Remove File \"$FILE\"${NC}"
        exit
    fi
fi
done
if [ ! -d "$CACHE_HOME" ]; then
    mkdir "$CACHE_HOME"
fi
if [ -f "$CACHE_HOME/agensgraph-jdbc-1.3.2.jar" ]; then
    echo -e "${GREEN}Copy File From Cache: \"agensgraph-jdbc-1.3.2.jar\"${NC}"
    cp "$CACHE_HOME/agensgraph-jdbc-1.3.2.jar" "agensgraph-jdbc-1.3.2.jar"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy File \"agensgraph-jdbc-1.3.2.jar\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download File: \"agensgraph-jdbc-1.3.2.jar\"${NC}"
    wget http://search.maven.org/remotecontent?filepath=net/bitnine/agensgraph-jdbc/1.3.2/agensgraph-jdbc-1.3.2.jar
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download File \"agensgraph-jdbc-1.3.2.jar\"${NC}"
        exit
    fi
    echo -e "${GREEN}Rename File: \"agensgraph-jdbc-1.3.2.jar\"${NC}"
    mv "remotecontent?filepath=net%2Fbitnine%2Fagensgraph-jdbc%2F1.3.2%2Fagensgraph-jdbc-1.3.2.jar" "agensgraph-jdbc-1.3.2.jar"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Rename File \"agensgraph-jdbc-1.3.2.jar\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/agensgraph-jdbc-1.3.2.jar"
        if [ $? -eq 0 ]; then
            cp -rf "agensgraph-jdbc-1.3.2.jar" "$CACHE_HOME/agensgraph-jdbc-1.3.2.jar"
        fi
    fi
fi
if [ -f "$CACHE_HOME/agensgraph-jdbc-1.4.0.jar" ]; then
    echo -e "${GREEN}Copy File From Cache: \"agensgraph-jdbc-1.4.0.jar\"${NC}"
    cp "$CACHE_HOME/agensgraph-jdbc-1.4.0.jar" "agensgraph-jdbc-1.4.0.jar"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy File \"agensgraph-jdbc-1.4.0.jar\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download File: \"agensgraph-jdbc-1.4.0.jar\"${NC}"
    wget http://search.maven.org/remotecontent?filepath=net/bitnine/agensgraph-jdbc/1.4.0/agensgraph-jdbc-1.4.0.jar
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download File \"agensgraph-jdbc-1.4.0.jar\"${NC}"
        exit
    fi
    echo -e "${GREEN}Rename File: \"agensgraph-jdbc-1.4.0.jar\"${NC}"
    mv "remotecontent?filepath=net%2Fbitnine%2Fagensgraph-jdbc%2F1.4.0%2Fagensgraph-jdbc-1.4.0.jar" "agensgraph-jdbc-1.4.0.jar"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Rename File \"agensgraph-jdbc-1.4.0.jar\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/agensgraph-jdbc-1.4.0.jar"
        if [ $? -eq 0 ]; then
            cp -rf "agensgraph-jdbc-1.4.0.jar" "$CACHE_HOME/agensgraph-jdbc-1.4.0.jar"
        fi
    fi
fi
if [ -d "$CACHE_HOME/agensgraph" ]; then
    echo -e "${GREEN}Copy Source From Cache: \"agensgraph\"${NC}"
    git clone "$CACHE_HOME/agensgraph"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy Source \"agensgraph\"${NC}"
        exit
    fi
    cd "$WORK_HOME/agensgraph"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME/agensgraph\"${NC}"
        exit
    fi
    for BRANCH in `git branch -r | grep -v /master`; do
        git branch "`basename \"$BRANCH\"`" "$BRANCH"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed: Add Remote Branch \"$BRANCH\"${NC}"
            exit
        fi
    done
    cd "$WORK_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download Source: \"agensgraph\"${NC}"
    git clone https://github.com/bitnine-oss/agensgraph.git
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download Source \"agensgraph\"${NC}"
        exit
    fi
    cd "$WORK_HOME/agensgraph"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME/agensgraph\"${NC}"
        exit
    fi
    for BRANCH in `git branch -r | grep -v /master`; do
        git branch "`basename \"$BRANCH\"`" "$BRANCH"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed: Add Remote Branch \"$BRANCH\"${NC}"
            exit
        fi
    done
    cd "$WORK_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/agensgraph"
        if [ $? -eq 0 ]; then
            cp -rf "agensgraph" "$CACHE_HOME/agensgraph"
        fi
    fi
fi
cd "$WORK_HOME/agensgraph"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME/agensgraph\"${NC}"
    exit
fi
git checkout "$GIT_BRANCH"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Checkout Branch \"$GIT_BRANCH\"${NC}"
    exit
fi
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi
if [ -d "$CACHE_HOME/ldbc_snb_driver" ]; then
    echo -e "${GREEN}Copy Source From Cache: \"ldbc_snb_driver\"${NC}"
    git clone "$CACHE_HOME/ldbc_snb_driver"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy Source \"ldbc_snb_driver\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download Source: \"ldbc_snb_driver\"${NC}"
    git clone https://github.com/ldbc/ldbc_snb_driver.git
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download Source \"ldbc_snb_driver\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/ldbc_snb_driver"
        if [ $? -eq 0 ]; then
            cp -rf "ldbc_snb_driver" "$CACHE_HOME/ldbc_snb_driver"
        fi
    fi
fi
if [ -d "$CACHE_HOME/ldbc-snb-agens-graph" ]; then
    echo -e "${GREEN}Copy Source From Cache: \"ldbc-snb-agens-graph\"${NC}"
    git clone "$CACHE_HOME/ldbc-snb-agens-graph"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy Source \"ldbc-snb-agens-graph\"${NC}"
        exit
    fi
    cd "$LDBC_SNB_AGENS_GRAPH_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
        exit
    fi
    for BRANCH in `git branch -r | grep -v /master`; do
        git branch "`basename \"$BRANCH\"`" "$BRANCH"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed: Add Remote Branch \"$BRANCH\"${NC}"
            exit
        fi
    done
    cd "$WORK_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download Source: \"ldbc-snb-agens-graph\"${NC}"
    git clone https://github.com/bitnine-oss/ldbc-snb-agens-graph
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download Source \"ldbc-snb-agens-graph\"${NC}"
        exit
    fi
    cd "$LDBC_SNB_AGENS_GRAPH_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
        exit
    fi
    for BRANCH in `git branch -r | grep -v /master`; do
        git branch "`basename \"$BRANCH\"`" "$BRANCH"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed: Add Remote Branch \"$BRANCH\"${NC}"
            exit
        fi
    done
    cd "$WORK_HOME"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/ldbc-snb-agens-graph"
        if [ $? -eq 0 ]; then
            cp -rf "ldbc-snb-agens-graph" "$CACHE_HOME/ldbc-snb-agens-graph"
        fi
    fi
fi
cd "$LDBC_SNB_AGENS_GRAPH_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
    exit
fi
git checkout "$GIT_BRANCH"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Checkout Branch \"$GIT_BRANCH\"${NC}"
    exit
fi
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# BUILD AGENSGRAPH

cd "$WORK_HOME/agensgraph"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME/agensgraph\"${NC}"
    exit
fi
echo -e "${GREEN}Configure Agens Graph Build Environment${NC}"
./configure "--prefix=$AGENS_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Configure Agens Graph Build Environment${NC}"
    exit
fi
echo -e "${GREEN}Build Agens Graph${NC}"
make
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Build Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Install Agens Graph${NC}"
make install-world
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Install Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Initialize Agens Graph${NC}"
initdb
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Initialize Agens Graph${NC}"
    exit
fi
cd "$AGDATA"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$AGDATA\"${NC}"
    exit
fi
echo -e "${GREEN}Modify Agens Graph Config${NC}"
cat postgresql.conf | sed "s/#port = 5432/port = $AGENS_PORT/" | sed "s/shared_buffers = 128MB/shared_buffers = $SHARED_BUFFERS/" | sed "s/#work_mem = 4MB/work_mem = $WORK_MEM/" | sed "s/#random_page_cost = 4.0/random_page_cost = $RANDOM_PAGE_COST/" >postgresql_modified.conf
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Agens Graph Config${NC}"
    exit
fi
mv -f postgresql.conf postgresql.conf.bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Agens Graph Config${NC}"
    exit
fi
mv postgresql_modified.conf postgresql.conf
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Agens Graph Config${NC}"
    exit
fi
echo -e "${GREEN}Changed Config File of Agens Graph"
diff postgresql.conf.bak postgresql.conf
echo -e -n "${NC}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Changed Config File of Agens Graph${NC}"
    exit
fi
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# BUILD DRIVER

cd "$LDBC_SNB_DRIVER_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_DRIVER_HOME\"${NC}"
    exit
fi
echo -e "${GREEN}Build Driver${NC}"
mvn -B clean install -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Build Driver${NC}"
    exit
fi
echo -e "${GREEN}Build Driver Completed${NC}"
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# BUILD IMPLEMENTATIONS

cd "$LDBC_SNB_AGENS_GRAPH_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
    exit
fi
echo -e "${GREEN}Build Implementations${NC}"
mvn -B clean compile assembly:single
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Build Implementations${NC}"
    exit
fi
echo -e "${GREEN}Build Implementations Completed${NC}"
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# CONVERT & IMPORT DATA

cd "$LDBC_SNB_AGENS_GRAPH_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
    exit
fi
echo -e "${GREEN}Start Agens Graph${NC}"
ag_ctl -w start
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Start Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Start Agens Graph Completed${NC}"
echo -e "${GREEN}Create Database${NC}"
createdb -p "$AGENS_PORT" "$USER"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Create Database${NC}"
    exit
fi
echo -e "${GREEN}Load Data${NC}"
sh load_agens.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Load Data${NC}"
    exit
fi
echo -e "${GREEN}Load Data Completed${NC}"
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# BACKUP & RESTART Agens Graph

echo -e "${GREEN}Stop Agens Graph${NC}"
ag_ctl stop
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Stop Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Stop Agens Graph Completed${NC}"
echo -e "${GREEN}Backup Agens Graph${NC}"
tar cvf agdata.tar pgsql/data
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Backup Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Backup Agens Graph Completed${NC}"
echo "$SCALE_FACTOR" >"$WORK_HOME/scalefactor"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Write Scale Factor${NC}"
    exit
fi
echo "$GIT_BRANCH" >"$WORK_HOME/gitbranch"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Write Git Branch${NC}"
    exit
fi
echo "$AGENS_PORT" >"$WORK_HOME/agensport"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Write Agens Port${NC}"
    exit
fi
echo "$SHARED_BUFFERS" >"$WORK_HOME/sharedbuffers"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Write Shared Buffers${NC}"
    exit
fi

fi # SKIP_LOAD

echo -e "${GREEN}`date`${NC}"

echo -e "${GREEN}Remove Agens Graph Data${NC}"
rm -rf pgsql/data
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Remove Agens Graph Data${NC}"
    exit
fi
echo -e "${GREEN}Remove Agens Graph Data Completed${NC}"
echo -e "${GREEN}Recover Agens Graph${NC}"
tar xvf agdata.tar
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Recover Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Recover Agens Graph Completed${NC}"
echo -e "${GREEN}Start Agens Graph${NC}"
ag_ctl -w start
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Start Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Start Agens Graph Completed${NC}"
echo -e "${GREEN}Prewarm Agens Graph${NC}"
agens -d "$USER" -p "$AGENS_PORT" -U "$USER" --echo-all -P pager=off -f "$LDBC_SNB_AGENS_GRAPH_HOME/prewarm.sql"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Prewarm Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Prewarm Agens Graph Completed${NC}"


echo -e "${GREEN}`date`${NC}"

# RUN TEST

cd "$LDBC_SNB_AGENS_GRAPH_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_AGENS_GRAPH_HOME\"${NC}"
    exit
fi
echo -e "${GREEN}Configure LDBC Social Network Benchmark${NC}"
cat ldbc-test.properties.template \
| sed "s/thread_count=2/thread_count=$THREAD_COUNT/" \
| sed "s/time_unit=MILLISECONDS/time_unit=MICROSECONDS/" \
| sed "s/time_compression_ratio=0.05/time_compression_ratio=$TIME_COMPRESSION_RATIO/" \
| sed "s/operation_count=1000/operation_count=$OPERATION_COUNT/" \
> ldbc-test.properties
echo -e "${GREEN}Changed Property Of LDBC_SNB_DRIVER"
diff ldbc-test.properties.template ldbc-test.properties
echo -e -n "${NC}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Changed Property Of LDBC_SNB_DRIVER${NC}"
    exit
fi
SCALE_FACTOR_FORMATTED=`awk '{ printf "%04d", $1 }' <<EOF
$SCALE_FACTOR
EOF`
echo -e "${GREEN}Start LDBC Social Network Benchmark${NC}"
if [ "$SKIP_TEST" = "FALSE" ]; then
    echo -e "${GREEN}SYNC : Write Cache To Disk${NC}"
    sync
    echo -e "${GREEN}RUN TEST : java -classpath \"$LDBC_SNB_DRIVER_HOME/target/jeeves-0.3-SNAPSHOT.jar:$LDBC_SNB_AGENS_GRAPH_HOME/target/ldbc-snb-impl-1.0-SNAPSHOT-jar-with-dependencies.jar:$WORK_HOME/$JDBC_JAR\" com.ldbc.driver.Client -P \"$LDBC_SNB_AGENS_GRAPH_HOME/ldbc-test.properties\" -P \"$LDBC_SNB_DRIVER_HOME/configuration/ldbc/snb/interactive/ldbc_snb_interactive_SF-${SCALE_FACTOR_FORMATTED}.properties\" -P \"$LDBC_SNB_DATAGEN_HOME/social_network/updateStream.properties\" -p ldbc.snb.interactive.parameters_dir \"$LDBC_SNB_DATAGEN_HOME/substitution_parameters\" -p ldbc.snb.interactive.updates_dir \"$LDBC_SNB_DATAGEN_HOME/social_network\" -p dbname \"$USER\" -p port \"$AGENS_PORT\" -p user \"$USER\"${NC}"
    dstat --nocolor --time --cpu --mem --disk --io --page --swap --net -N lo >"$WORK_HOME/dstat.log" &
    DSTAT_PID=$!
    java -classpath "$LDBC_SNB_DRIVER_HOME/target/jeeves-0.3-SNAPSHOT.jar:$LDBC_SNB_AGENS_GRAPH_HOME/target/ldbc-snb-impl-1.0-SNAPSHOT-jar-with-dependencies.jar:$WORK_HOME/$JDBC_JAR" com.ldbc.driver.Client -P "$LDBC_SNB_AGENS_GRAPH_HOME/ldbc-test.properties" -P "$LDBC_SNB_DRIVER_HOME/configuration/ldbc/snb/interactive/ldbc_snb_interactive_SF-${SCALE_FACTOR_FORMATTED}.properties" -P "$LDBC_SNB_DATAGEN_HOME/social_network/updateStream.properties" -p ldbc.snb.interactive.parameters_dir "$LDBC_SNB_DATAGEN_HOME/substitution_parameters" -p ldbc.snb.interactive.updates_dir "$LDBC_SNB_DATAGEN_HOME/social_network" -p dbname "$USER" -p port "$AGENS_PORT" -p user "$USER"
    kill "$DSTAT_PID"
else
    echo -e "${GREEN}SKIP TEST : java -classpath \"$LDBC_SNB_DRIVER_HOME/target/jeeves-0.3-SNAPSHOT.jar:$LDBC_SNB_AGENS_GRAPH_HOME/target/ldbc-snb-impl-1.0-SNAPSHOT-jar-with-dependencies.jar:$WORK_HOME/$JDBC_JAR\" com.ldbc.driver.Client -P \"$LDBC_SNB_AGENS_GRAPH_HOME/ldbc-test.properties\" -P \"$LDBC_SNB_DRIVER_HOME/configuration/ldbc/snb/interactive/ldbc_snb_interactive_SF-${SCALE_FACTOR_FORMATTED}.properties\" -P \"$LDBC_SNB_DATAGEN_HOME/social_network/updateStream.properties\" -p ldbc.snb.interactive.parameters_dir \"$LDBC_SNB_DATAGEN_HOME/substitution_parameters\" -p ldbc.snb.interactive.updates_dir \"$LDBC_SNB_DATAGEN_HOME/social_network\" -p dbname \"$USER\" -p port \"$AGENS_PORT\" -p user \"$USER\"${NC}"
fi
echo -e "${GREEN}LDBC Social Network Benchmark Completed${NC}"
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


echo -e "${GREEN}`date`${NC}"

# STOP Agens Graph

echo -e "${GREEN}Stop Agens Graph${NC}"
ag_ctl stop
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Stop Agens Graph${NC}"
    exit
fi
echo -e "${GREEN}Stop Agens Graph Completed${NC}"

echo -e "${GREEN}`date`${NC}"
