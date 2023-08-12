#! /bin/bash

printf "Do you want me to create a username and password ? (y/n): "
read mup
while [[ -z "$mup" ]] || [[ !("$mup" =~ ^[nNyY]+$) ]] || [[ ${#mup} -gt 1 ]]
do
    echo "Invalid value, Try again"
    printf "Do you want me to create a username and password ? (y/n): "
    read mup
done

lowermup=$(echo "$mup" | tr '[:upper:]' '[:lower:]')

if [[ "$lowermup" == "y" ]]
then
    username=$(tr -dc 'a-z0-9' </dev/urandom | head -c 24  ; echo)
    while [[ "$username" =~ ^[0-9] ]]
    do
        username=$(tr -dc 'a-z0-9' </dev/urandom | head -c 24  ; echo)
    done

    password=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*;[\]^{|}~' </dev/urandom | head -c 24  ; echo)
else
    printf "Username : "
    read username
    while [[ -z "$username" ]] || [[ !("$username" =~ ^[a-z0-9]+$) ]] || [[ "$username" == *" "* ]] || [[ "$username" =~ ^[0-9] ]] || id "$username" &>/dev/null
    do
        if id "$username" &>/dev/null
        then
            echo "This username exists, Try again"
        fi
        if [[ -z "$username" ]]
        then
            echo "Username cannot be empty, Try again"
        fi
        if [[ !("$username" =~ ^[a-z0-9]+$) ]] || [[ "$username" == *" "* ]]
        then
            echo "Username can only contain lowercase letters and numbers, Try again"
        fi
        if [[ "$username" =~ ^[0-9] ]]
        then
            echo "Username cannot start with a number, Try again"
        fi
        printf "Username : "
        read username
    done

    printf "Password : "
    read -s password
    rtpassword='3rzh4Zt9&ATUwqqX7GM^gqk2XM18mS3r4xTC91OqUft#t61ICQ6^Bunb7Kuo1G5#5BPIJH8tSoj0%uABh610fZdiD2!65N0YdDgd5iH4K$u3iSYILlMK6gkKJr*ZxA2qe#6!l1S3pIJfJnN8&2MoAI'
    while [[ "$password" !=  "$rtpassword" ]]
    do
        while [[ -z "$password" ]] || [[ "$password" == *" "* ]] || [[ "$password" == *"-"* ]] || [[ "$password" == *"_"* ]] || [[ "$password" == *"@"* ]]
        do
            if [[ -z "$password" ]]
            then
                echo "Password cannot be empty, Try again"
            fi
            if [[ "$password" == *" "* ]]
            then
                echo "The password cannot contain spaces, Try again"
            fi
            if [[ "$password" == *"-"* ]] || [[ "$password" == *"_"* ]] || [[ "$password" == *"@"* ]]
            then
                echo "The password cannot contain these characters : -_@, Try again"
            fi
            printf "Password : "
            read -s password
        done

        printf "\nRetype password : "
        read -s rtpassword
        while [[ -z "$rtpassword" ]] || [[ "$rtpassword" == *" "* ]] || [[ "$rtpassword" == *"-"* ]] || [[ "$rtpassword" == *"_"* ]] || [[ "$rtpassword" == *"@"* ]]
        do
            if [[ -z "$rtpassword" ]]
            then
                echo "Password cannot be empty, Try again"
            fi
            if [[ "$rtpassword" == *" "* ]]
            then
                echo "The password cannot contain spaces, Try again"
            fi
            if [[ "$rtpassword" == *"-"* ]] || [[ "$rtpassword" == *"_"* ]] || [[ "$rtpassword" == *"@"* ]]
            then
                echo "The password cannot contain these characters : -_@, Try again"
            fi
            printf "\nRetype password : "
            read -s rtpassword
        done
    done
fi

if [[ "$lowermup" == "y" ]]
then
    printf "Full Name : "
else
    printf "\nFull Name : "
fi
read fullname

printf "Destination Group : "
read group
while [[ !($(getent group "$group")) ]]
do
    echo "There is no group with this name, Try again"
    printf "Destination Group : "
    read group
done

printf "day : "
read da
while [[ !( -z "$da" ) ]] && [[ !("$da" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "day : "
    read da
done

if [[ -z "$da" ]]
then
    accountexpires="Never"
    useradd -c "$fullname" -g "$group" -M -p "$password" -s /bin/false "$username"
    { echo -e "$password\n$password" | passwd "$username"; } &> /dev/null
else
    da=$(($da + 1))
    accountexpires=$(date -d "+$da days" +%Y-%m-%d)
    useradd -c "$fullname" -e "$accountexpires" -g "$group" -M -p "$password" -s /bin/false "$username"
    { echo -e "$password\n$password" | passwd "$username"; } &> /dev/null
fi

{ adduser "$username" "$group"; } &> /dev/null

echo ""
echo "---------------------------------------------------------"
echo "---------------------------------------------------------"
echo "Username : $username"
echo "Password : $password"
echo "Full Name : $fullname"
echo "Primary Group : $group"
echo "Account Expires : $accountexpires"
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