#! /bin/bash

clear

echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@&GG#&@@@#!!P@@@@@@@@@&&&&@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P7!#@@@@@@@
@@G.     &@@P  !@@@@@@@@&    #@@7  7@@@@@@@@@@@@@@##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!  P@@@@@@@
@&   !##P&@@P  7@@@@@@@@&    .&@!  !@@@@@@@@@@@@@P  7@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7  P@@@@@@@
@@.  .5@@@@@P  7@@@@@@@@&     .&7  7@@@#! ..^5@@?     @^..&@Y..B@G. J@@?.   ^B@@@...P: &@7  G@?. :#@
@@@J.   J@@@P  7@@@@@@@@&   5  .~  7@@&  .#Y  J@G^  .?@B  !@   ^@.  &@:  ?P.  B@@   .7?@@7  ?^  ~&@@
@@@@@G.  ~@@P  7@@@@@@@@&   &B     7@@P  .!~...@@G  7@@@!  J ^  ?  G@&   @@G  !@@   #@@@@7  .  .@@@@
@@5YBB.  .@@P  !@@@@@@@@&   &@B    !@@&  .&&YYB@@P  !@@@@    #Y   ^@@@.  P#~  5@@   &@@@@!  PY  ^&@@
@@?    .!&@@G  7@@@@@@@@&   &@@P   7@@@G. .. !&@@G  7@@@@P  ^@@   &@@@&^    .J@@@   &@@@@7  G@5  :&@
@@@&##&@@@@@@&&@@@@@@@@@@&&&@@@@&&&@@@@@@&##@@@@@@&&@@@@@@&&@@@@&&@@@@@@&##&@@@@@&&&@@@@@@&&@@@&&&&@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo -e "\n\n"
echo -e "1\tUser Connection Limit"
echo -e "2\tUser Connection Limit + User Expiration Date"
echo -e "\n\n"
printf "Choose one of the options : "
read op
while [[ !( -z "$op" ) ]] && [[ !("$op" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Choose one of the options : "
    read op
done
printf "Number of connections per user : "
read noc
while [[ !( -z "$noc" ) ]] && [[ !("$noc" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Number of connections per user : "
    read noc
done
if [[ $op -eq 1 ]]
then
    echo '#! /bin/bash

    limit=${noc}
    c=$(pgrep -xcu "$PAM_USER" sshd)
    if [[ "$PAM_USER" != "root" ]] && [[ $c -ge $limit ]]
    then
        pkill -u "$PAM_USER"
        exit 1
    else
        exit 0
    fi
    ' > /etc/userlimit
elif [[ $op -eq 2 ]]
then
    timedatectl set-timezone Asia/Tehran
    echo '#! /bin/bash

    expirationtime=$(chage -l "$PAM_USER" | grep 'Account expires')
    et=${expirationtime#*: }
    if [[ "$et" == "never" ]]
    then
        math=1
    else
        expirationtime=$(date +"%s" -d "$et")
        timenow=$(date +"%s")
        math=$((expirationtime-timenow))
    fi


    if [[ $math -gt 0 ]]
    then
        limit=${noc}
        c=$(ps -u "$PAM_USER" | grep sshd | wc -l)
        if [[ "$PAM_USER" != "root" ]] && [[ $c -ge $limit ]]
        then
            pkill -u "$PAM_USER"
            exit 1
        else
            exit 0
        fi
    else
        exit 1
    fi
    '
else
    exit 1
fi

{ chmod -v +x /etc/userlimit; } &> /dev/null

echo '\n' >> /etc/pam.d/sshd

if  grep -Fxq "account    required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    echo ''
else
    echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi

if  grep -Fxq "auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    echo ''
else
    echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi


