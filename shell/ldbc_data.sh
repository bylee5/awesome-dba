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
SCALE_FACTOR=1


# CHECK ENVIRONMENT

echo -e "${GREEN}Check Shell: \"bash\"${NC}"
if [ "`basename \"$SHELL\"`" != "bash" ]; then
    echo -e "${RED}Failed: Shell MUST BE \"bash\"${NC}"
    exit
fi

echo -e "${GREEN}Check Script: \"ldbc_data.sh\"${NC}"
if [ "`basename \"$BASH_SOURCE\"`" != "ldbc_data.sh" ]; then
    echo -e "${RED}Failed: Script File MUST BE \"ldbc_data.sh\"${NC}"
    exit
fi

echo -e "${GREEN}Check Directory: \"ldbc_data\"${NC}"
if [ "`basename \"$WORK_HOME\"`" != "ldbc_data" ]; then
    echo -e "${RED}Failed: Working Directory MUST BE \"ldbc_data\"${NC}"
    exit
fi


# PARSE ARGUMENTS

for ARG in "$@"; do
    K=`echo "$ARG"|cut -d '=' -f 1`
    V=`echo "$ARG"|cut -d '=' -f 2`
    case "$K" in
        "--scale-factor")
          case "$V" in
            1|3|10|30|100|300|1000)
              SCALE_FACTOR="$V"
              ;;
            *)
              echo -e "${RED}Failed: Invalid Scale Factor - Select Within \"1,3,10,30,100,300,1000\"${NC}"
              exit
              ;;
          esac
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
          echo -e "Usage: ldbc_data.sh [--scale-factor=1|3|10|30|100|300|1000]"
          echo -e -n "${NC}"
          exit
          ;;
    esac
done


# SET ENVIRONMENT VARIABLES

export MAVEN_HOME="$WORK_HOME/apache-maven-3.5.2"
export HADOOP_HOME="$WORK_HOME/hadoop-2.6.0"
export PATH="$MAVEN_HOME/bin:$PATH"
export HADOOP_CLIENT_OPTS="-Xmx1G"
export LDBC_SNB_DATAGEN_HOME="$WORK_HOME/ldbc_snb_datagen"

echo -e "${GREEN}export WORK_HOME=\"$WORK_HOME\"${NC}"
echo -e "${GREEN}export CACHE_HOME=\"$CACHE_HOME\"${NC}"
echo -e "${GREEN}export MAVEN_HOME=\"$MAVEN_HOME\"${NC}"
echo -e "${GREEN}export HADOOP_HOME=\"$HADOOP_HOME\"${NC}"
echo -e "${GREEN}export PATH=\"$PATH\"${NC}"
echo -e "${GREEN}export LDBC_SNB_DATAGEN_HOME=\"$LDBC_SNB_DATAGEN_HOME\"${NC}"
echo -e "${GREEN}export HADOOP_CLIENT_OPTS=\"$HADOOP_CLIENT_OPTS\"${NC}"
echo -e "${GREEN}export SCALE_FACTOR=$SCALE_FACTOR${NC}"


# DOWNLOAD PACKAGES & SOURCES

for FILE in `ls`; do
if [ "$FILE" != "ldbc_data.sh" ]; then
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
if [ -f "$CACHE_HOME/apache-maven-3.5.2-bin.tar.gz" ]; then
    echo -e "${GREEN}Copy File From Cache: \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
    cp "$CACHE_HOME/apache-maven-3.5.2-bin.tar.gz" "apache-maven-3.5.2-bin.tar.gz"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy File \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download File: \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
    wget http://apache.mirror.cdnetworks.com/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download File \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/apache-maven-3.5.2-bin.tar.gz"
        if [ $? -eq 0 ]; then
            cp -rf "apache-maven-3.5.2-bin.tar.gz" "$CACHE_HOME/apache-maven-3.5.2-bin.tar.gz"
        fi
    fi
fi
if [ -f "$CACHE_HOME/hadoop-2.6.0.tar.gz" ]; then
    echo -e "${GREEN}Copy File From Cache: \"hadoop-2.6.0.tar.gz\"${NC}"
    cp "$CACHE_HOME/hadoop-2.6.0.tar.gz" "hadoop-2.6.0.tar.gz"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy File \"hadoop-2.6.0.tar.gz\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download File: \"hadoop-2.6.0.tar.gz\"${NC}"
    wget http://archive.apache.org/dist/hadoop/core/hadoop-2.6.0/hadoop-2.6.0.tar.gz
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download File \"hadoop-2.6.0.tar.gz\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/hadoop-2.6.0.tar.gz"
        if [ $? -eq 0 ]; then
            cp -rf "hadoop-2.6.0.tar.gz" "$CACHE_HOME/hadoop-2.6.0.tar.gz"
        fi
    fi
fi
echo -e "${GREEN}Unarchive Package: \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
tar xzf "apache-maven-3.5.2-bin.tar.gz"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Unarchive Package \"apache-maven-3.5.2-bin.tar.gz\"${NC}"
    exit
fi
echo -e "${GREEN}Unarchive Package: \"hadoop-2.6.0\"${NC}"
tar xzf "hadoop-2.6.0.tar.gz"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Unarchive Package \"hadoop-2.6.0.tar.gz\"${NC}"
    exit
fi
if [ -d "$CACHE_HOME/ldbc_snb_datagen" ]; then
    echo -e "${GREEN}Copy Source From Cache: \"ldbc_snb_datagen\"${NC}"
    git clone "$CACHE_HOME/ldbc_snb_datagen"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Copy Source \"ldbc_snb_datagen\"${NC}"
        exit
    fi
else
    echo -e "${GREEN}Download Source: \"ldbc_snb_datagen\"${NC}"
    git clone https://github.com/ldbc/ldbc_snb_datagen
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Download Source \"ldbc_snb_datagen\"${NC}"
        exit
    fi
    if [ -d "$CACHE_HOME" ]; then
        rm -rf "$CACHE_HOME/ldbc_snb_datagen"
        if [ $? -eq 0 ]; then
            cp -rf "ldbc_snb_datagen" "$CACHE_HOME/ldbc_snb_datagen"
        fi
    fi
fi


# GENERATE DATA

cd "$LDBC_SNB_DATAGEN_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_DATAGEN_HOME\"${NC}"
    exit
fi
echo -e "${GREEN}Modify Data Generator Parameter${NC}"
echo "ldbc.snb.datagen.generator.scaleFactor:snb.interactive.$SCALE_FACTOR" >params_modified.ini
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Data Generator Parameter${NC}"
    exit
fi
grep -v ldbc.snb.datagen.generator.scaleFactor params.ini >>params_modified.ini
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Data Generator Parameter${NC}"
    exit
fi
mv -f params.ini params.ini.bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Data Generator Parameter${NC}"
    exit
fi
mv params_modified.ini params.ini
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Data Generator Parameter${NC}"
    exit
fi
echo -e "${GREEN}Changed Parameter of LDBC_SNB_DATAGEN"
diff params.ini.bak params.ini
echo -e -n "${NC}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Changed Parameter of LDBC_SNB_DATAGEN${NC}"
    exit
fi
echo -e "${GREEN}Modify Shell Script For LDBC_SNB_DATAGEN${NC}"
cat run.sh | sed "s/mvn /mvn -B /g" >run_modified.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Shell Script For LDBC_SNB_DATAGEN${NC}"
    exit
fi
mv -f run.sh run.sh.bak
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Shell Script For LDBC_SNB_DATAGEN${NC}"
    exit
fi
mv run_modified.sh run.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Shell Script For LDBC_SNB_DATAGEN${NC}"
    exit
fi
chmod ugo+x run.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Modify Shell Script For LDBC_SNB_DATAGEN${NC}"
    exit
fi
echo -e "${GREEN}Modified Shell Script Of LDBC_SNB_DATAGEN"
diff run.sh.bak run.sh
echo -e -n "${NC}"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Changed Modified Shell Script Of LDBC_SNB_DATAGEN${NC}"
    exit
fi
echo -e "${GREEN}Generate Data: SCALE_FACTOR=$SCALE_FACTOR${NC}"
./run.sh
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Generate Data${NC}"
    exit
fi
echo -e "${GREEN}Generate Data Completed: SCALE_FACTOR=$SCALE_FACTOR${NC}"
cd "$LDBC_SNB_DATAGEN_HOME/substitution_parameters"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$LDBC_SNB_DATAGEN_HOME\"${NC}"
    exit
fi
for FILE in `ls bi_*_param.txt`; do
    ln -s "$FILE" "q`echo \"$FILE\" | cut -b 4-`"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Link File \"$FILE\"${NC}"
        exit
    fi
done
for FILE in `ls interactive_*_param.txt`; do
    ln -s "$FILE" "query_`echo \"$FILE\" | cut -b 13-`"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed: Link File \"$FILE\"${NC}"
        exit
    fi
done
cd "$WORK_HOME"
if [ $? -ne 0 ]; then
    echo -e "${RED}Failed: Change Directory \"$WORK_HOME\"${NC}"
    exit
fi


# WRITE SCALEFACTOR

echo "$SCALE_FACTOR" >scalefactor
