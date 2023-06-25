#!/bin/bash
NODES() {
    # master节点数
    MAS_NM=$(grep "master:" ./conf/hp.yaml | awk '{print $NF}' | tr '[' ' ' | tr ']' ' ' | tr ',' ' ' | awk '{print NF}')
    # node节点数
    NDS_NM=$(grep "nodes:" ./conf/hp.yaml | awk '{print $NF}' | tr '[' ' ' | tr ']' ' ' | tr ',' ' ' | awk '{print NF}')

    for MS in $(grep "master" ./conf/hp.yaml | awk '{print $NF}' | tr '[' ' ' | tr ']' ' ' | tr ',' ' ' | tr '"' ' ' | xargs)
    do
	sed -ri "/\[manager\]/a${MS}" ./ansible/inventory
    done

    for NS in $(grep "nodes:" ./conf/hp.yaml | awk '{print $NF}' | tr '[' ' ' | tr ']' ' ' | tr ',' ' ' | tr '"' ' ' | xargs)
    do
	sed -ri "/\[node\]/a${NS}" ./ansible/inventory
    done
    if [ "$(grep ssh_online ./conf/hp.yaml | awk '{print $2}')" == "true" ];then
	#SPW=$(grep ssh_pass ./conf/hp.yaml | awk '{print $2}')
	SPW=$(awk '/^HADOOP/,/^[[:space:]]*node_data/{print}' ./conf/hp.yaml | awk '/ssh_pass:/{print $2}' | tr '"' ' ' | tr "'" " " |  xargs | base64 --decode)
	[ ! -z $SPW ] && echo "ansible_ssh_pass=${SPW}" >> ./ansible/inventory
    else
	[ ! -f /root/.ssh/id_rsa ] && ssh-keygen -C "manager@master" -P "" -N "" -f /root/.ssh/id_rsa
	for i in $(grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' ./ansible/inventory | sort -rn | uniq | xargs)
	do
	    ssh-copy-id root@$i
	done
    fi
}
