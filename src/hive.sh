#!/bin/bash
# 
# 修改初始化密码，允许远程登陆
mysql_secure() {
rpm -q expect &>/dev/null
[ $? -ne 0 ] && yum install -y expect &>/dev/null 
export dbpsw=$(grep 'password is gen' /var/log/mysqld.log | grep 'root@localhost' | awk '{print $NF}')
/usr/bin/expect <<-END
spawn mysql_secure_installation
expect "Enter password for user root:"
send "${dbpsw}\r"

expect "New password:"
send "${dbpsw}\r"

expect "Re-enter new password:"
send "${dbpsw}\r"

expect "Change the password for root ? ((Press y|Y for Yes, any other key for No) : "
send "n\r"

expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"

expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "n\r"

expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "n\r"

expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) : "
send "y\r"
END
}

# 修改或者输出显示密码，创建root@%用户
mysql_init() {
    yum install -y mysql mysql-server
    [ -f /etc/my.cnf ] && rm -f /etc/my.cnf
    ln ./static/my.cnf /etc/my.cnf 
    systemctl enable --now mysqld
    # dbpsw=$(grep 'password is gen' /var/log/mysqld.log | grep 'root@localhost' | awk '{print $NF}')
    mysql_secure
    mysql -uroot -p${dbpsw} -e "create user 'root'@'%' identified by '${dbpsw}';grant all privileges on *.* to 'root'@'%';flush privileges;"
    . ./src/ui.sh
    CGPSW=$(inputcos KunTower "是否更改密码(yes/no)" yes no)
    if [ $? -eq 0 ];then
	dbpsw2=$(inputpass KunTower "输入要更改的密码")
        mysql -uroot -p${dbpsw} -e "alter user 'root'@'localhost' identified by '${dbpsw2}';flush privileges;"
        dbpsw=${dbpsw2}
    else
	echo "`green ${dbpsw} 记住你的密码`"
    fi
}
