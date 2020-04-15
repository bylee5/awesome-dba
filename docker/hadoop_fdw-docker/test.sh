
#!/bin/bash

_AG_JDBC_VERSION=1.4.2

if [ ! -d log ]; then
	mkdir log
fi

for _HADOOP_VERSION in 3.1.1 3.0.3 3.0.2 2.9.1 2.9.0 2.8.5 2.8.4 2.7.7 2.7.6 2.6.5
do
	for _HIVE_VERSION in 3.1.1 2.3.3 1.2.2
	do
			for _AG_VERSION in 2.0.0 # 2.0.0 or higher
			do
				if [ \( "${_HADOOP_VERSION:0:1}" -eq "${_HIVE_VERSION:0:1}" \) -o \( "${_HIVE_VERSION:0:1}" -eq "1" -a "${_HADOOP_VERSION:0:1}" -eq "2" \) ]; then
					docker rmi $(docker images -f "dangling=true" -q)
					docker build --build-arg HADOOP_VERSION=${_HADOOP_VERSION} --build-arg HIVE_VERSION=${_HIVE_VERSION} --build-arg AG_VERSION=${_AG_VERSION} --build-arg AG_JDBC_VERSION=${_AG_JDBC_VERSION} -t hadoop-hive-agens:${_HADOOP_VERSION}.${_HIVE_VERSION}.${_AG_VERSION}.${_AG_JDBC_VERSION} ./
					docker run --rm hadoop-hive-agens:"${_HADOOP_VERSION}.${_HIVE_VERSION}.${_AG_VERSION}.${_AG_JDBC_VERSION}"
					if [ $? -eq 0 ]; then
						echo "$(date): $_HADOOP_VERSION + $_HIVE_VERSION + $_AG_VERSION -> succeeded!" >> log/$(date "+%Y-%m-%d").log 	
					else
						echo "$(date): $_HADOOP_VERSION + $_HIVE_VERSION + $_AG_VERSION -> failed!" >> log/$(date "+%Y-%m-%d").log
						exit 1	
					fi
				fi
			done
	done
done

exit 0
