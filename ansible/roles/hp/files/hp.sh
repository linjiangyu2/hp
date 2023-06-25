export JAVA_HOME=/usr/local/jdk
export HADOOP_HOME=/opt/hadoop285
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native 
export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib/native"
export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native/:$LD_LIBRARY_PATH
export PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/sbin:$PATH
