#! /bin/bash

allusers=$(cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1)

allusers=$(echo "$allusers" | xargs)

IFS=' '
read -ra au <<< "$allusers"

for user in "${au[@]}"
do
    expirationtime=$(chage -l $user | grep 'Account expires')
    et=${expirationtime#*: }
    if [[ "$et" == "never" ]]
    then
        math=1
    else
        expirationtime=$(date +"%s" -d "$et")
        timenow=$(date +"%s")
        math=$((expirationtime-timenow))
    fi
    if [[ $math -le 0 ]]
    then
        pkill -u $user
    fi
done

































if command -v lsof > /dev/null 2>&1; then
    :
else
    NEEDRESTART_MODE=a apt install lsof -y
fi

while true
do

clear

port=$(grep -oE 'Port [0-9]+' /etc/ssh/sshd_config | cut -d' ' -f2)

onlineuser=$(sudo lsof -i :$port -n | grep ESTABLISHED)

onlineuser=$(echo "$onlineuser" | xargs)

IFS=' '
read -ra ouser <<< "$onlineuser"

i=2
ou=()
while [[ $i -le ${#ouser[@]} ]]
do
    ou+=(${ouser[$i]})
    i=$(($i + 10))
done

ous=$(echo "${ou[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

IFS=' '
read -ra ousort <<< "$ous"

i=0
while [[ $i -lt ${#ousort[@]} ]]
do
    getname=$(getent passwd "${ousort[$i]}")
    IFS=':'
    read -ra gname <<< "$getname"
    printf '%-26s---------> %s\n' "${ousort[$i]}" "${gname[4]}"
    expirationtime=$(chage -l "${ousort[$i]}" | grep 'Account expires')
    et=${expirationtime#*: }
    if [[ "$et" == "never" ]]
    then
        math=1
    else
        expirationtime=$(date +"%s" -d "$et")
        timenow=$(date +"%s")
        math=$((expirationtime-timenow))
    fi
    if [[ $math -le 0 ]]
    then
        pkill -u ${ousort[$i]}
    fi
    i=$(($i + 1))
done

sleep 5s

done

