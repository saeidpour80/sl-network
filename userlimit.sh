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
echo -e "\n"
echo -e "1)\tUser Connection Limit"
echo -e "2)\tUser Connection Limit + User Expiration Date"
echo -e "3)\tExit"
echo -e "\n"
printf "Choose one of the options : "
read op
while [[ !( -z "$op" ) ]] && [[ !("$op" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Choose one of the options : "
    read op
done
if [[ $op -eq 1 ]]
then
    printf "Number of connections per user : "
    read noc
    while [[ !( -z "$noc" ) ]] && [[ !("$noc" =~ ^[0-9]+$) ]]
    do
        echo "Invalid value, Try again"
        printf "Number of connections per user : "
        read noc
    done
    { rm /etc/userlimit; } &> /dev/null
    echo '#! /bin/bash' >> /etc/userlimit
    echo '' >> /etc/userlimit
    echo "limit=$noc" >> /etc/userlimit
    echo 'c=$(ps -u "$PAM_USER" | grep sshd | wc -l)' >> /etc/userlimit
    echo 'if [[ "$PAM_USER" != "root" ]] && [[ $c -ge $limit ]]' >> /etc/userlimit
    echo 'then' >> /etc/userlimit
    echo '    pkill -u "$PAM_USER"' >> /etc/userlimit
    echo '    exit 1' >> /etc/userlimit
    echo 'else' >> /etc/userlimit
    echo '    exit 0' >> /etc/userlimit
    echo 'fi' >> /etc/userlimit
    echo '' >> /etc/userlimit
elif [[ $op -eq 2 ]]
then
    printf "Number of connections per user : "
    read noc
    while [[ !( -z "$noc" ) ]] && [[ !("$noc" =~ ^[0-9]+$) ]]
    do
        echo "Invalid value, Try again"
        printf "Number of connections per user : "
        read noc
    done
    timedatectl set-timezone Asia/Tehran
    { rm /etc/userlimit; } &> /dev/null
    echo '#! /bin/bash' >> /etc/userlimit
    echo '' >> /etc/userlimit
    echo 'expirationtime=$(chage -l "$PAM_USER" | grep "Account expires")' >> /etc/userlimit
    echo 'et=${expirationtime#*: }' >> /etc/userlimit
    echo 'if [[ "$et" == "never" ]]' >> /etc/userlimit
    echo 'then' >> /etc/userlimit
    echo '    math=1' >> /etc/userlimit
    echo 'else' >> /etc/userlimit
    echo '    expirationtime=$(date +"%s" -d "$et")' >> /etc/userlimit
    echo '    timenow=$(date +"%s")' >> /etc/userlimit
    echo '    math=$((expirationtime-timenow))' >> /etc/userlimit
    echo 'fi' >> /etc/userlimit
    echo '' >> /etc/userlimit
    echo '' >> /etc/userlimit
    echo 'if [[ $math -gt 0 ]]' >> /etc/userlimit
    echo 'then' >> /etc/userlimit
    echo "    limit=$noc" >> /etc/userlimit
    echo '    c=$(ps -u "$PAM_USER" | grep sshd | wc -l)' >> /etc/userlimit
    echo '    if [[ "$PAM_USER" != "root" ]] && [[ $c -ge $limit ]]' >> /etc/userlimit
    echo '    then' >> /etc/userlimit
    echo '        pkill -u "$PAM_USER"' >> /etc/userlimit
    echo '        exit 1' >> /etc/userlimit
    echo '    else' >> /etc/userlimit
    echo '        exit 0' >> /etc/userlimit
    echo '    fi' >> /etc/userlimit
    echo 'else' >> /etc/userlimit
    echo '    exit 1' >> /etc/userlimit
    echo 'fi' >> /etc/userlimit
    echo '' >> /etc/userlimit
else
    exit 1
fi

{ chmod -v +x /etc/userlimit; } &> /dev/null

if  grep -Fxq "account    required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo -e '\n' >> /etc/pam.d/sshd
    echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi

if  grep -Fxq "auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi


