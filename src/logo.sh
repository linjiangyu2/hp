#!/bin/bash
logo() {
	echo "                                              "
	echo "	 _  __             _____                      "
	echo "	| |/ /   _ _ __   |_   _|____      _____ _ __"
	echo "	| ' / | | | '_ \    | |/ _ \ \ /\ / / _ \ '__|"
	echo "	| . \ |_| | | | |   | | (_) \ V  V /  __/ |   "
	echo "	|_|\_\__,_|_| |_|   |_|\___/ \_/\_/ \___|_|"
	echo "                                              "
}

rlogo() {
	source src/verification.sh
	source src/color.sh
	command -v jp2a &>/dev/null
	if [ $(echo $?) -ne 0 ]; then
		# 如果本机命令不存在就检测系统版本安装
		source src/os.sh
		os
		case $dist in
		centos)
			yum install -y https://mirrors.linjiangyu.com/centos/tianlin-release.noarch-7-1.x86_64.rpm &>/dev/null
			yum install -y jp2a &>/dev/null
			jp2a --background=light image/$(($(($RANDOM % $(ls image/ | wc -l))) + 1)).jpg
			;;
		*)
			break
			;;
		esac
	else
		# 如果本机命令存在就随机显示
		jp2a --background=light image/$(($(($RANDOM % $(ls image/ | wc -l))) + 1)).jpg
	fi
}
