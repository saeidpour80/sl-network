#! /bin/bash

Color_Off='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

timedatectl set-timezone Asia/Tehran
NEEDRESTART_MODE=a apt update -y
NEEDRESTART_MODE=a apt upgrade -y
NEEDRESTART_MODE=a apt install nano -y
NEEDRESTART_MODE=a apt install expect -y

echo "7555" | bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/XPanel-SSH-User-Management/master/fix-call.sh --ipv4)

clear

printf "IP : "
read fsip
while [[ -z "$fsip" ]] || [[ !("$fsip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$) ]]
do
    echo "Invalid value, Try again"
    printf "IP : "
    read fsip
done
printf "Port : "
read fsport
while [[ -z "$fsport" ]] || [[ !("$fsport" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Port : "
    read fsport
done
printf "Password : "
read fspass
while [[ -z "$fspass" ]]
do
    echo "Invalid value, Try again"
    printf "Password : "
    read fspass
done

echo ""

mkdir /root/restore
echo '#!/usr/bin/expect' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -o StrictHostKeyChecking=no -P $fsport root@$fsip:/etc/passwd /root/restore/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$fspass\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/group /root/restore/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$fspass\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/shadow /root/restore/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$fspass\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/gshadow /root/restore/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$fspass\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
echo '' >> /bin/getbackup.sh
echo "spawn scp -P $fsport root@$fsip:/etc/ssh/sshd_config /root/restore/" >> /bin/getbackup.sh
echo 'expect "password:"' >> /bin/getbackup.sh
echo "send \"$fspass\r\"" >> /bin/getbackup.sh
echo 'expect eof' >> /bin/getbackup.sh
chmod -v +x /bin/getbackup.sh
getbackup.sh 
sleep 1s
rm /bin/getbackup.sh

check=0
if [[ -f /root/restore/passwd ]] && [[ -f /root/restore/group ]] && [[ -f /root/restore/shadow ]] && [[ -f /root/restore/gshadow ]] && [[ -f /root/restore/sshd_config ]]
then
    check=1
fi

if [[ $check -eq 1 ]]
then
    getpasswd=$(awk 'p; /videocall/{p=1}' /root/restore/passwd)
    echo "$getpasswd" >> /etc/passwd
    getgroup=$(awk 'p; /videocall/{p=1}' /root/restore/group)
    echo "$getgroup" >> /etc/group
    getshadow=$(awk 'p; /videocall/{p=1}' /root/restore/shadow)
    echo "$getshadow" >> /etc/shadow
    getgshadow=$(awk 'p; /videocall/{p=1}' /root/restore/gshadow)
    echo "$getgshadow" >> /etc/gshadow
    port=$(grep -oE 'Port [0-9]+' /root/restore/sshd_config | cut -d' ' -f2)
    sed -i "s/#Port 22/Port $port/" /etc/ssh/sshd_config
    sleep 1s
    rm -rf /root/restore
    echo -e "\n${Green}Successful${Color_Off}\n"
    printf "Do you agree with rebooting the server ? (y/n): "
    read ra
    while [[ -z "$ra" ]] || [[ !("$ra" =~ ^[nNyY]+$) ]] || [[ ${#ra} -gt 1 ]]
    do
        echo "Invalid value, Try again"
        printf "Do you agree with rebooting the server ? (y/n): "
        read ra
    done
    lowerrs=$(echo "$ra" | tr '[:upper:]' '[:lower:]')
    if [[ "$lowerrs" == "y" ]]
    then
        sleep 2s
        reboot
    fi
else
    echo -e "\n${Red}Error${Color_Off}\n"
fi
