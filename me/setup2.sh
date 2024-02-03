#! /bin/bash

timedatectl set-timezone Asia/Tehran
apt update -y
apt upgrade -y
apt install curl -y
apt install sudo
apt install cron -y
systemctl enable cron
apt install expect -y
apt install nano -y

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
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/clir2.sh -O /bin/clir.sh
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
sudo service cron restart

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/sshd_config -O /etc/ssh/sshd_config
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/ssh_config -O /etc/ssh/ssh_config

check=0
while [[ $check -eq 0 ]]
do
    clear
    printf "Foreign server IP : "
    read fsip
    while [[ -z "$fsip" ]] || [[ !("$fsip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$) ]]
    do
        echo "Invalid value, Try again"
        printf "Foreign server IP : "
        read fsip
    done
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
        fspasse="YjBxZCo4eXchI0BoIUI1Nk9AZEFHaGxlcwo="
    else
        fspasse=$(echo  "$fspass" | base64)
    fi
    printf "\nIran server IP : "
    read isip
    while [[ !( -z "$isip" ) ]] && [[ !("$isip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$) ]]
    do
        echo "Invalid value, Try again"
        printf "Iran server IP : "
        read isip
    done
    if [[ -z "$isip" ]]
    then
        isipe="MTg1LjIxNS4yMzEuMgo="
    else
        isipe=$(echo  "$isip" | base64)
    fi
    printf "Iran server port : "
    read isport
    while [[ !( -z "$isport" ) ]] && [[ !("$isport" =~ ^[0-9]+$) ]]
    do
        echo "Invalid value, Try again"
        printf "Iran server port : "
        read isport
    done
    if [[ -z "$isport" ]]
    then
        isport="22"
    fi
    printf "Iran server password : "
    read -s ispass
    if [[ -z "$ispass" ]]
    then
        ispasse="JEA3MDgyNDQwU2EK"
    else
        ispasse=$(echo  "$ispass" | base64)
    fi
    printf "\nIran server tunnel password : "
    read -s istpass
    if [[ -z "$istpass" ]]
    then
        istpasse="JEA3MDgyNDQwU2EK"
    else
        istpasse=$(echo  "$istpass" | base64)
    fi

    echo ""

    mkdir /root/restore
    echo '#!/usr/bin/expect' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo 'set timeout 60' >> /bin/getbackup.sh
    echo "spawn scp -o StrictHostKeyChecking=no -P $fsport root@$fsip:/etc/useractivityhistory.txt /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo "spawn scp -P $fsport root@$fsip:/etc/passwd /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo "spawn scp -P $fsport root@$fsip:/etc/group /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo "spawn scp -P $fsport root@$fsip:/etc/shadow /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo "spawn scp -P $fsport root@$fsip:/etc/gshadow /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo "spawn scp -r -P $fsport root@$fsip:/etc/letsencrypt /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    echo '' >> /bin/getbackup.sh
    echo "spawn scp -r -P $fsport root@$fsip:/etc/x-ui /root/restore/" >> /bin/getbackup.sh
    echo 'expect "password:"' >> /bin/getbackup.sh
    echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/getbackup.sh
    echo 'expect eof' >> /bin/getbackup.sh
    chmod -v +x /bin/getbackup.sh
    getbackup.sh 
    sleep 1s
    rm /bin/getbackup.sh
    if [[ -f /root/restore/useractivityhistory.txt ]] && [[ -f /root/restore/passwd ]] && [[ -f /root/restore/group ]] && [[ -f /root/restore/shadow ]] && [[ -f /root/restore/gshadow ]] && [[ -d /root/restore/letsencrypt ]] && [[ -d /root/restore/x-ui ]]
    then
        copy_status=0
        yes | cp -rf /root/restore/useractivityhistory.txt /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/passwd /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/group /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/shadow /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/gshadow /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/letsencrypt /etc/
        copy_status=$(($copy_status + $?))
        yes | cp -rf /root/restore/x-ui /etc/
        copy_status=$(($copy_status + $?))
        sleep 1s
        rm -rf /root/restore
        if [[ $copy_status -eq 0 ]]
        then
            check=1
        else
            check=0
        fi
    fi
done

echo "n" | bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
echo '#!/usr/bin/expect' >> /bin/setupxui.sh
echo '' >> /bin/setupxui.sh
echo 'set timeout 60' >> /bin/setupxui.sh
echo 'spawn x-ui' >> /bin/setupxui.sh
echo 'expect "Please enter your selection"' >> /bin/setupxui.sh
echo 'send "18\r"' >> /bin/setupxui.sh
echo 'expect "Choose an option"' >> /bin/setupxui.sh
echo 'send "1\r"' >> /bin/setupxui.sh
echo 'expect "Proceed with installation of Fail2ban & IP Limit?"' >> /bin/setupxui.sh
echo 'send "y\r"' >> /bin/setupxui.sh
echo 'expect "Press enter to return to the main menu"' >> /bin/setupxui.sh
echo 'send "\r"' >> /bin/setupxui.sh
echo 'expect "Please enter your selection"' >> /bin/setupxui.sh
echo 'send "18\r"' >> /bin/setupxui.sh
echo 'expect "Choose an option"' >> /bin/setupxui.sh
echo 'send "2\r"' >> /bin/setupxui.sh
echo 'expect "Please enter new Ban Duration in Minutes"' >> /bin/setupxui.sh
echo 'send "15\r"' >> /bin/setupxui.sh
echo 'expect "Choose an option"' >> /bin/setupxui.sh
echo 'send "0\r"' >> /bin/setupxui.sh
echo 'expect "Please enter your selection"' >> /bin/setupxui.sh
echo 'send "0\r"' >> /bin/setupxui.sh
echo 'expect eof' >> /bin/setupxui.sh
chmod -v +x /bin/setupxui.sh
setupxui.sh
sleep 1s
rm /bin/setupxui.sh

echo '#!/bin/bash' >> /bin/installtunnel.sh
echo '' >> /bin/installtunnel.sh
echo 'bash <(curl -fsSL https://raw.githubusercontent.com/radkesvat/ReverseTlsTunnel/master/scripts/RtTunnel.sh)' >> /bin/installtunnel.sh
chmod -v +x /bin/installtunnel.sh
echo '#!/usr/bin/expect' >> /bin/setuptunnel.sh
echo '' >> /bin/setuptunnel.sh
echo 'set timeout 60' >> /bin/setuptunnel.sh
echo 'spawn installtunnel.sh' >> /bin/setuptunnel.sh
echo 'expect "Please choose"' >> /bin/setuptunnel.sh
echo 'send "1\r"' >> /bin/setuptunnel.sh
echo 'expect "Do you want to install the Latest version?"' >> /bin/setuptunnel.sh
echo 'send "yes\r"' >> /bin/setuptunnel.sh
echo 'expect "Which server do you want to use?"' >> /bin/setuptunnel.sh
echo 'send "2\r"' >> /bin/setuptunnel.sh
echo 'expect "Please Enter SNI"' >> /bin/setuptunnel.sh
echo 'send "digikala.com\r"' >> /bin/setuptunnel.sh
echo 'expect "Please Enter IRAN IP"' >> /bin/setuptunnel.sh
echo "send \"$(echo "$isipe" | base64 --decode)\r\"" >> /bin/setuptunnel.sh
echo 'expect "Please Enter Password"' >> /bin/setuptunnel.sh
echo "send \"$(echo "$istpasse" | base64 --decode)\r\"" >> /bin/setuptunnel.sh
echo 'expect eof' >> /bin/setuptunnel.sh
echo 'set timeout 5' >> /bin/setuptunnel.sh
echo "spawn ssh -o StrictHostKeyChecking=no -p $fsport root@$fsip" >> /bin/setuptunnel.sh
echo 'expect "password:"' >> /bin/setuptunnel.sh
echo "send \"$(echo "$fspasse" | base64 --decode)\r\"" >> /bin/setuptunnel.sh
echo 'expect "#"' >> /bin/setuptunnel.sh
echo 'send "shutdown -h now\r"' >> /bin/setuptunnel.sh
echo 'send "exit\r"' >> /bin/setuptunnel.sh
echo 'expect eof' >> /bin/setuptunnel.sh
echo 'set timeout 5' >> /bin/setuptunnel.sh
echo "spawn ssh -o StrictHostKeyChecking=no -p $isport debian@$(echo "$isipe" | base64 --decode)" >> /bin/setuptunnel.sh
echo 'expect "password:"' >> /bin/setuptunnel.sh
echo "send \"$(echo "$ispasse" | base64 --decode)\r\"" >> /bin/setuptunnel.sh
echo 'expect "$"' >> /bin/setuptunnel.sh
echo 'send "re\r"' >> /bin/setuptunnel.sh
echo 'send "exit\r"' >> /bin/setuptunnel.sh
echo 'expect eof' >> /bin/setuptunnel.sh
chmod -v +x /bin/setuptunnel.sh
setuptunnel.sh
sleep 1s
rm /bin/setuptunnel.sh
rm /bin/installtunnel.sh

port=$(grep -oE 'Port [0-9]+' /etc/ssh/sshd_config | cut -d' ' -f2)
mkdir /root/iptables_rules
iptables-save > /root/iptables_rules/iptables-backup.txt
apt install iptables ipset -y
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/root/firewall.txt -O /root/iptables_rules/firewall.txt
#-------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------#
# echo '#!/bin/bash' >> /root/iptables_rules/apply.sh
# echo '' >> /root/iptables_rules/apply.sh
# echo 'iptables -F' >> /root/iptables_rules/apply.sh
# echo "iptables -A INPUT -p tcp --dport $port -j ACCEPT" >> /root/iptables_rules/apply.sh
# echo 'ipset create whitelist hash:net' >> /root/iptables_rules/apply.sh
# echo 'while read line; do ipset add whitelist $line; done < /root/iptables_rules/firewall.txt' >> /root/iptables_rules/apply.sh
# echo 'iptables -A INPUT -m set --match-set whitelist src -j ACCEPT' >> /root/iptables_rules/apply.sh
# echo 'iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT' >> /root/iptables_rules/apply.sh
# echo 'iptables -I INPUT 1 -i lo -j ACCEPT' >> /root/iptables_rules/apply.sh
# echo 'iptables -A INPUT -j DROP' >> /root/iptables_rules/apply.sh
#-------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------#
echo '#!/bin/bash' >> /root/iptables_rules/apply.sh
echo '' >> /root/iptables_rules/apply.sh
echo 'iptables -F' >> /root/iptables_rules/apply.sh
echo 'ipset create whitelist hash:net' >> /root/iptables_rules/apply.sh
echo 'while read line; do ipset add whitelist $line; done < /root/iptables_rules/firewall.txt' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -p tcp --dport 22 -m set --match-set whitelist src -j ACCEPT' >> /root/iptables_rules/apply.sh
echo "iptables -A INPUT -p tcp --dport $port -m set --match-set whitelist src -j ACCEPT" >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -p tcp -m set --match-set whitelist src -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -m set --match-set whitelist src -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -A OUTPUT -m set --match-set whitelist src -j DROP' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -I INPUT 1 -i lo -j ACCEPT' >> /root/iptables_rules/apply.sh
echo 'iptables -A INPUT -j DROP' >> /root/iptables_rules/apply.sh
#-------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------#
chmod -v +x /root/iptables_rules/apply.sh
/root/iptables_rules/apply.sh

clne.sh

sleep 5s

systemctl restart sshd
systemctl restart ssh
