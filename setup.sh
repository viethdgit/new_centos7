#!/bin/sh

\cp conf/limits.conf /etc/security/limits.conf
\cp conf/selinux /etc/sysconfig/selinux
\cp conf/sysctl.conf /etc/sysctl.conf
\cp conf/rc.local /etc/rc.d/rc.local
\cp conf/os/cron.allow /etc/cron.allow

yum install epel-release ntpdate iptables-services net-tools wget -y

systemctl stop postfix
systemctl disable postfix

systemctl disable firewalld
systemctl stop firewalld

systemctl start iptables
systemctl enable iptables

sysctl -p

echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag

timedatectl set-timezone Asia/Ho_Chi_Minh
ntpdate time.google.com
crontab -l | { cat; echo '*/15 * * * * /usr/sbin/ntpdate time.google.com' ; } | crontab -

chmod +x /etc/rc.d/rc.local
systemctl enable rc-local
systemctl start rc-local


echo 'Done!'

