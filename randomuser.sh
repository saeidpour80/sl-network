#! /bin/bash

timedatectl set-timezone Asia/Tehran
clear

if command -v lsof > /dev/null 2>&1; then
    :
else
    NEEDRESTART_MODE=a apt install lsof -y
fi

lowermup="y"

if [[ "$lowermup" == "y" ]]
then
    username=$(tr -dc 'a-z0-9' </dev/urandom | head -c 24  ; echo)
    while [[ "$username" =~ ^[0-9] ]]
    do
        username=$(tr -dc 'a-z0-9' </dev/urandom | head -c 24  ; echo)
    done

    password=$(tr -dc 'A-Za-z0-9!#$%&()*;[\]^{|}~' </dev/urandom | head -c 24  ; echo)
    while [[ !( "$password" =~ ^[A-Za-z0-9] ) ]]
    do
        password=$(tr -dc 'A-Za-z0-9!#$%&()*;[\]^{|}~' </dev/urandom | head -c 24  ; echo)
    done
fi

if [[ !($(getent group vpn1user)) ]]
then
    { addgroup vpn1user; } &> /dev/null
fi
group="vpn1user"


useradd -g "$group" -M -p "$password" -s /bin/false "$username"
{ echo -e "$password\n$password" | passwd "$username"; } &> /dev/null

{ adduser "$username" "$group"; } &> /dev/null

echo ""
echo "---------------------------------------------------------"
echo "---------------------------------------------------------"
echo "SSH Host : "
ssh_port=$(grep -oE 'Port [0-9]+' /etc/ssh/sshd_config | cut -d' ' -f2)
echo "SSH Port : $ssh_port"
udpgw_port=$(lsof -i -P -n | grep videocall | grep LISTEN | grep -oE ':[0-9]+' | cut -d':' -f2)
echo "Udpgw Port : $udpgw_port"
echo "SSH Username : $username"
echo "SSH Password : $password"
echo "---------------------------------------------------------"
echo "---------------------------------------------------------"
