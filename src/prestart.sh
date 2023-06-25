#!/bin/bash
. /src/require.sh
YUM_ALI() {
   mkdir /etc/yum.repos.d/bak
   mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/
   eval "$(curl -q https://developer.aliyun.com/mirror/centos 2>&1 | grep curl | awk -F'>' '{print $3}' | grep $version)"
   yum install -y epel-release &>/dev/null
   sed -e 's!^metalink=!#metalink=!g' \
    -e 's!^#baseurl=!baseurl=!g' \
    -e 's!https\?://download\.fedoraproject\.org/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' \
    -e 's!https\?://download\.example/pub/epel!https://mirrors.tuna.tsinghua.edu.cn/epel!g' \
    -i /etc/yum.repos.d/epel*.repo
   yum clean all &>/dev/null && yum makecache fast &>dev/null
   yum install -y chrony vim git net-tools aria2 &>/dev/null
   systemctl disable --now firewalld
}
soft() {
    if ! command -v aria2c &>/dev/null ;then
    yum install -y https://hp.linjiangyu.com/aria2-1.34.0-5.el7.x86_64.rpm
    fi
    [ -d /opt/kuntower ] && mv /opt/kuntower /opt/kuntower.bak
    aria2c -s $(nproc) -c https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/stable2/hadoop-2.10.2.tar.gz -d /opt/kuntower/soft -o hadoop.tar.gz
    wget -O /opt/kuntower/soft/jdk.tar.gz https://repo.huaweicloud.com/java/jdk/8u191-b12/jdk-8u191-linux-x64.tar.gz
    aria2c -s $(nproc) -c https://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz -d /opt/kuntower/soft -o spark.tgz
    aria2c -s $(nproc) -c https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz -d /opt/kuntower/soft -o hive.tar.gz
    yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-7.noarch.rpm
    sed -ri 's@(gpgcheck=)1@\10@g' /etc/yum.repos.d/mysql*.repo
    for TAR in $(ls /opt/kuntower/soft | xargs)
    do
        tar xf /opt/kuntower/soft/$TAR -C /opt/kuntower/soft/ && rm -f /opt/kutower/soft/$TAR
    done
    mv /opt/kuntower/soft/jdk1.8.0_191 $(grep -i 'JAVA_HOME:' ./conf/hp.yaml | awk '{print $2}')
    mv /opt/kuntower/soft/hadoop-2.10.2 $(sed '/^HADOOP,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
    # mv /opt/kuntower/soft/apache-hive-3.1.2-bin $(sed '/^HIVE,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
    # mv /opt/kutower/soft/spark-3.3.2-bin-hadoop3 $(sed '/^SPARK,^#\-.*/p' ./conf/hp.yaml | grep home | awk '{print $2}')
}
chy() {
   export df_ipv4=$(hostname -i | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}")
   sed -i -e 's@^server@#server@g' -e "\$aserver _gateway\nserver $df_ipv4 iburst" -e 's@^#\(local.*\)@\1@g' /etc/chrony.conf
   systemctl enable --now chronyd
}
sshkeyga(){
   for i in $(cat ./conf/hp.yaml | awk '/^[[:space:]]*master:.*/,/^[[:space:]]*nodes:/{print $2}' | tr '[' ' ' | tr ']' '  ' | tr '"' ' ' | tr ',' ' ' | xargs)
   do 
	ssh-copy-id root@$i
   done
}
