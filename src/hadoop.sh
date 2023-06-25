#!/bin/bash
# 
#untar() {
#    for TAR in $(ls /opt/kuntower/soft/ | grep ".*.tar.*")
#    do
#	tar xf /opt/kutower/soft/$TAR && rm -f /opt/kutower/soft/$TAR
#    done
#    mv /opt/kuntower/soft/jdk1.8.0_191 $(grep -i 'JAVA_HOME:' ./conf/hp.yaml | awk '{print $2}')
#    mv /opt/kuntower/soft/hadoop-2.10.2	$(sed '/^HADOOP,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
    # mv /opt/kuntower/soft/apache-hive-3.1.2-bin $(sed '/^HIVE,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
    # mv /opt/kutower/soft/spark-3.3.2-bin-hadoop3 $(sed '/^SPARK,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
#}
