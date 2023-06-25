#!/bin/bash
syc() {
/usr/bin/expect <<-END
spawn rsync -av ./my.cnf root@192.168.222.33:/root/1
expect {
"yes/no" { send "yes\r";exp_continue }
"password:" { send "123\r";exp_continue }
}
END
}
