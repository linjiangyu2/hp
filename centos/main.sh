#!/bin/bash
# 
export JAVA_HOME=${JAVA_HOME:-/usr/local/jdk}
export DST_JAVA=$(echo ${JAVA_HOME} | awk -F'/' '{ sub("/" $NF,"");print $0"/"}')
export HADOOP_HOME=$(cat ./conf/hp.yaml | sed -rn '/^HADOOP/,/^[^([:upper:]|[:space:])]/p' | grep -w "home:" | awk '{print $2}')
export DST_HADOOP=$(echo ${HADOOP_HOME} | awk -F'/' '{ sub("/" $NF,"");print $0"/"}')
export LISTEN=$(cat ./conf/hp.yaml | awk '/^[[:space:]]+listen.*/{print $2}')
export TMP_PATH=$(cat ./conf/hp.yaml | awk '/^[[:space:]]+tmp.*/{print $2}')
export REPLICA=$(cat ./conf/hp.yaml | awk '/^[[:space:]]+replica:/{print $2}')
export REPLICA_DIR=$(cat ./conf/hp.yaml | awk '/^[[:space:]]+replica_dir:/{print $2}')
export NODE_DATA_DIR=$(cat ./conf/hp.yaml | awk '/^[[:space:]]+node_data_dir:/{print $2}')
MAIN() {
MSTIP=$(hostname -i | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}")
sed -ri "s@^(server).*(iburst)@\1${MSTIP}\2@g" ./ansible/roles/chrony/files/chrony.conf
cp -a /etc/yum.repos.d ./ansible/roles/hp/files/yum.repos.d
cd ./ansible
sed -ri "s@^(export JAVA_HOME=).*@\1$(grep -w 'JAVA_HOME:' ../conf/hp.yaml | awk '{print $2}')@g" ./roles/hp/files/hp.sh
sed -ri "s@^(export HADOOP_HOME=).*@\1$(cat ../conf/hp.yaml | sed -rn '/^HADOOP/,/^[^([:upper:]|[:space:])]/p' | grep -w "home:" | awk '{print $2}')@g" ./roles/hp/files/hp.sh
sed -ri "s@JAVA_HOME@${JAVA_HOME}@g" ./roles/hp/tasks/main.yml
sed -ri "s@^([[:space:]]*- hd:.*)@& ${HADOOP_HOME}@g" ./prestart.yml 
#sed -ri "/^[[:space:]]*.*(regexp1)/,/^[[:space:]]*.*(regexp2)/s@([[:space:]]*path:).*@\1 $(cat ../conf/hp.yaml | sed -rn '/^HADOOP/,/^[^([:upper:]|[:space:])]/p' | grep -w "home:" | awk '{print $2}')/etc/hadoop/hadoop-env.sh@g" ./roles/hp/tasks/main.yml
#sed -ri "/^[[:space:]]*.*(hadoop)/,/^[[:space:]]*.*(regexp1)/s@^[[:space:]]*src:.*@& ${HADOOP_HOME}@g" ./roles/hp/tasks/main.yml
#sed -ri "/^[[:space:]]*.*(hadoop)/,/^[[:space:]]*.*(regexp1)/s@^[[:space:]]*dest:.*@& ${HADOOP_HOME}@g" ./roles/hp/tasks/main.yml
#sed -ri "/^[[:space:]]*.*(regexp1)/,/^[[:space:]]*.*(regexp2)/s@([[:space:]]*line:).*@\1 ${JAVA_HOME}@g" ./prestart.yml
#sed -ri "/^[[:space:]]*.*(regexp1)/,/^[[:space:]]*.*(regexp2)/s@^[[:space:]].*line:.*@& ${JAVA_HOME}@g" ./roles/hp/tasks/main.yml
#sed -ri "/^[[:space:]]*.*(regexp2)/,/^[[:space:]]*.*(regexp3)/s@^[[:space:]]*path:.*@& ${HADOOP_HOME}/etc/hadoop/yarn-env.sh@g" ./roles/hp/tasks/main.yml
#sed -ri "/^[[:space:]]*.*(regexp2)/,/^[[:space:]]*.*(regexp3)/s@^[[:space:]]*line:.*@& export JAVA_HOME=${JAVA_HOME}@g" ./roles/hp/tasks/main.yml
sed -i "s@HD_HOME@${HADOOP_HOME}@g" ./roles/hp/tasks/main.yml
MASTER_HOST=$(hostname)
sed -i -e "s@TMP_DIR@${TMP_PATH}@g" -e "s@LISTEN@${LISTEN}@g" ./roles/hp/templates/core-site.j2
sed -i "s@MAS_HOST@${MASTER_HOST}@g" ./roles/hp/templates/core-site.j2
sed -i -e "s@NODE_DIR@${REPLICA_DIR}@g" -e "s@RSNM@${REPLICA}@g" -e "s@NODEDATA_DIR@${NODE_DATA_DIR}@g" ./roles/hp/templates/hdfs-site.j2
sed -i "s@JA_HOME@${JAVA_HOME}@g" ./roles/hp/templates/hadoop-env.j2
sed -i "s@master@${MASTER_HOST}@g" ./roles/hp/templates/yarn-site.j2
sed -i "s@DST_HD@${DST_HADOOP}@g" ./roles/hp/tasks/main.yml
sed -i "s@DST_JA@${DST_JAVA}@g" ./roles/hp/tasks/main.yml
sed -i "s@JA_HOME@${JAVA_HOME}@g" ./roles/hp/templates/yarn-env.j2
ansible-playbook prestart.yml
${HADOOP_HOME}/bin/hdfs namenode -format
ln -s ${HADOOP_HOME}/sbin/start-all.sh /usr/local/bin/start-all.sh
echo -e "\033[31m使用 ${HADOOP_HOME}/sbin/start-all.sh 命令启动集群\0m"
ln -s ${JAVA_HOME}/bin/java /usr/local/bin/java
ln -s ${JAVA_HOME}/bin/jps /usr/local/bin/jps
}

MAIN
