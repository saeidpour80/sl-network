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
