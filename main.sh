#!/bin/bash
# @ORG: KunTower
# @Date: 20230621
# @Modify: Tianlin
dist=$(cat /etc/os-release | head -1 | awk -F'=' '{ print $2 }' | cut -d' ' -f1 | cut -d'"' -f2 | tr '[:upper:]' '[:lower:]')
version=$(cat /etc/os-release | grep VERSION_ID | grep -o '[0-9]*' | head -1)
kernel=$(uname -r | cut -d. -f1)
kerbasearch=$(uname -p)
root() {
    [ $(id -u) -ne 0 ] && echo "$(red '当前不是root用户')" && exit 1
}

check_include_src_mod(){
    for modlist in $@
      do
        if [ -f ./src/${modlist}.sh ];then
          . ./src/${modlist}.sh 2>&1 &> /dev/null
        else
          echo -e "\033[31mfailed found mod in ./src/${modlist}.sh"
        fi
      done
}

MAIN(){
    # src/下模块导入
    check_include_src_mod color logo prestart ui hive rsync gatcher
    root
    logo
    while [ -z $OPTIONS ]
    do
      OPTIONS=$(whiptail --title "KunTower" --menu "检测到系统发行版为$(echo $dist | tr '[[:lower:]]' '[[:upper:]]')系统，如果有误请自己选择" 15 60 4 \
	"1" "CentOS" \
	"2" "!Debian" \
	"3" "!Ubuntu" 3>&1 1>&2 2>&3
	)
	[ $? -ne 0 ] && exit 0
    done

    case $OPTIONS in
	1)
	NODES
	soft
	sshkeyga
	chy
	sh ./centos/main.sh
	;;
	2)
	;;
	3)
	;;
    esac
}

MAIN
