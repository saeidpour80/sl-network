#! /bin/bash

apt install expect -y

clear

printf "IP : "
read fsip
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

sleep 1s

reboot
