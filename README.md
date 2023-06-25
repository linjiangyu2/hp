# hp

#### 介绍
大数据集群自动化搭建工具

#### 软件架构
软件架构说明


#### 安装教程
```shell
# git clone https://gitee.com/linjiangyu2/hp.git
# cd hp/conf
# vim hp.yaml 
```

#### 使用说明
修改配置文件
```yaml
# hp KunTower conf file
#
JAVA_HOME: /usr/local/jdk

#-------------------------hadoop------------------------#
HADOOP:
  master: ["192.168.222.32"]        # 管理节点的机器IP,也可以写成domain
  nodes: ["192.168.222.33","192.168.222.34"]    # 工作节点的机器IP
  ssh_online: true                              # 各节点的ssh密码是否一致(false/true)
  ssh_pass: 123                                 # 如果一致的话,写入密码（base64）
  home: /opt/hadoop285                          # hadoop安装路径
  listen: 9000                                  # 监听端口
  tmp: /opt/data                                # tmp路径
  replica: 1                                    # 副本数
  replica_dir: /opt/data/hdfs/name              # 副本详情数据路径
  node_data_dir: /opt/data/hdfs/data            # 副本数据路径
#------------------------hadoop------------------------#
```
