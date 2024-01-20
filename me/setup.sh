#! /bin/bash

timedatectl set-timezone Asia/Tehran
apt update -y
apt upgrade -y
apt install curl -y
apt install sudo
apt install cron -y
systemctl enable cron
apt install expect -y

echo "7555" | bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/XPanel-SSH-User-Management/master/fix-call.sh --ipv4)

apt install nginx -y
wget www.crazygames.com
cp index.html /var/www/html/

apt install certbot -y

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/userlimit -O /etc/userlimit
chmod -v +x /etc/userlimit
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/userlogout -O /etc/userlogout
chmod -v +x /etc/userlogout
sed -i '/@include common-password/d' /etc/pam.d/sshd
sed -i '$d' /etc/pam.d/sshd
echo -e '#userlimit' >> /etc/pam.d/sshd
echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
echo 'session optional pam_exec.so quiet /etc/userlogout' >> /etc/pam.d/sshd
echo '' >> /etc/pam.d/sshd
echo '# Standard Un*x password updating.' >> /etc/pam.d/sshd
echo '@include common-password' >> /etc/pam.d/sshd

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/guser -O /bin/guser
chmod -v +x /bin/guser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/euser -O /bin/euser
chmod -v +x /bin/euser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/ealluser -O /bin/ealluser
chmod -v +x /bin/ealluser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/ucl -O /bin/ucl
chmod -v +x /bin/ucl
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/onlineuser -O /bin/onlineuser
chmod -v +x /bin/onlineuser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/suser -O /bin/suser
chmod -v +x /bin/suser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/btt.sh -O /bin/btt.sh
chmod -v +x /bin/btt.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/clir.sh -O /bin/clir.sh
chmod -v +x /bin/clir.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/clne.sh -O /bin/clne.sh
chmod -v +x /bin/clne.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/getping.sh -O /bin/getping.sh
chmod -v +x /bin/getping.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/keu.sh -O /bin/keu.sh
chmod -v +x /bin/keu.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/re -O /bin/re
chmod -v +x /bin/re
crontab -l > mycron
echo "0,15,30,45 * * * * re" >> mycron
echo "0,30 * * * * getping.sh" >> mycron
echo "0 0 * * * btt.sh; keu.sh; rm -f /bin/re.txt" >> mycron
crontab mycron
rm mycron

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/sshd_config -O /etc/ssh/sshd_config
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/ssh_config -O /etc/ssh/ssh_config

clear

printf "Foreign server IP : "
read fsip
printf "Foreign server Port : "
read fsport
while [[ !( -z "$fsport" ) ]] && [[ !("$fsport" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Foreign server port : "
    read fsport
done
if [[ -z "$fsport" ]]
then
    fsport="6406"
fi
printf "Foreign server password : "
read -s fspass
if [[ -z "$fspass" ]]
then
    fspass="YjBxZCo4eXchI0BoIUI1Nk9AZEFHaGxlcwo="
else
    fspass=$(echo  $fspass | base64)
fi

echo ""

echo '#!/usr/bin/expect' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -o StrictHostKeyChecking=no -P $fsport root@$fsip:/etc/useractivityhistory.txt /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/passwd /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/group /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/shadow /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/gshadow /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -r -P $fsport root@$fsip:/etc/letsencrypt /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -r -P $fsport root@$fsip:/etc/x-ui /etc/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$(echo $fspass | base64 --decode)\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
chmod -v +x /bin/getbackup.sh
getbackup.sh
sleep 1s
rm /bin/getbackup.sh

echo "n" | bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
bash <(curl -fsSL https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)

port=$(grep -oE 'Port [0-9]+' /etc/ssh/sshd_config | cut -d' ' -f2)
mkdir /root/iptables_rules
iptables-save > /root/iptables_rules/iptables-backup.txt
apt install iptables ipset -y
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/root/firewall.txt -O /root/iptables_rules/firewall.txt
echo '#!/bin/bash' >> /root/iptables_rules/apply.sh
echo '' >> /root/iptables_rules/apply.sh
echo 'iptables -F' >> /root/iptables_rules/apply.sh
echo "iptables -A INPUT -p tcp --dport $port -j ACCEPT" >> /root/iptables_rules/apply.sh
echo 'ipset create whitelist hash:net' >> /root/iptables_rules/apply.sh
echo 'while read line; do ipset add whitelist $line; done < /root/iptables_rules/firewall.txt' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -m set --match-set whitelist src -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -I INPUT 1 -i lo -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -j DROP' >> /root/iptables_rules/apply.sh
chmod -v +x /root/iptables_rules/apply.sh
/root/iptables_rules/apply.sh
/root/iptables_rules/apply.sh

sleep 5s

reboot