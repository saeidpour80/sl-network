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
printf "\n"
echo -e "1) \033[4;31mUser connection limit\[0m"
echo -e "2) User connection limit + User expiration date"
echo -e "3) User connection limit + Set expiration date after first connection"
echo -e "4) User connection limit + User expiration date + Set expiration date after first connection"
echo -e "5) Remove script"
echo -e "6) Exit"
printf "\n"
printf "Choose one of the options : "
read op
while [[ !( -z "$op" ) ]] && [[ !("$op" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Choose one of the options : "
    read op
done
if [[ $op -eq 1 ]] || [[ $op -eq 3 ]]
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
    if [[ $op -eq 3 ]]
    then
        printf "Set the expiration date for how many days after the first connection ? : "
        read edafc
        while [[ !( -z "$edafc" ) ]] && [[ !("$edafc" =~ ^[0-9]+$) ]]
        do
            echo "Invalid value, Try again"
            printf "Set the expiration date for how many days after the first connection ? : "
            read edafc
        done
        echo 'if [[ "$PAM_USER" != "root" ]]' >> /etc/userlimit
        echo 'then' >> /etc/userlimit
        echo '    getuserexpirationdate=$(chage -l "$PAM_USER" | grep "Account expires")' >> /etc/userlimit
        echo '    gued=${getuserexpirationdate#*: }' >> /etc/userlimit
        echo '    if [[ "$gued" == "never" ]]' >> /etc/userlimit
        echo '    then' >> /etc/userlimit
        echo "        edafc_b=$(($edafc + 1))" >> /etc/userlimit
        echo '        setuseraccountexpires=$(date -d "+$edafc_b days" +%Y-%m-%d)' >> /etc/userlimit
        echo '        usermod -e "$setuseraccountexpires" "$PAM_USER"' >> /etc/userlimit
        echo '    fi' >> /etc/userlimit
        echo 'fi' >> /etc/userlimit
        echo '' >> /etc/userlimit
    fi
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
elif [[ $op -eq 2 ]] || [[ $op -eq 4 ]]
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
    if [[ $op -eq 4 ]]
    then
        printf "Set the expiration date for how many days after the first connection ? : "
        read edafc
        while [[ !( -z "$edafc" ) ]] && [[ !("$edafc" =~ ^[0-9]+$) ]]
        do
            echo "Invalid value, Try again"
            printf "Set the expiration date for how many days after the first connection ? : "
            read edafc
        done
        echo 'if [[ "$PAM_USER" != "root" ]]' >> /etc/userlimit
        echo 'then' >> /etc/userlimit
        echo '    getuserexpirationdate=$(chage -l "$PAM_USER" | grep "Account expires")' >> /etc/userlimit
        echo '    gued=${getuserexpirationdate#*: }' >> /etc/userlimit
        echo '    if [[ "$gued" == "never" ]]' >> /etc/userlimit
        echo '    then' >> /etc/userlimit
        echo "        edafc_b=$(($edafc + 1))" >> /etc/userlimit
        echo '        setuseraccountexpires=$(date -d "+$edafc_b days" +%Y-%m-%d)' >> /etc/userlimit
        echo '        usermod -e "$setuseraccountexpires" "$PAM_USER"' >> /etc/userlimit
        echo '    fi' >> /etc/userlimit
        echo 'fi' >> /etc/userlimit
        echo '' >> /etc/userlimit
    fi
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
elif [[ $op -eq 5 ]]
then
    { rm /etc/userlimit; } &> /dev/null
    grep -v "^#userlimit
account    required     pam_exec.so /etc/userlimit
auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd > /tmp/ul && mv /tmp/ul /etc/pam.d/sshd
    { rm /tmp/ul; } &> /dev/null
    exit 1
else
    exit 1
fi

{ chmod -v +x /etc/userlimit; } &> /dev/null

if  grep -Fxq "account    required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo -e '\n' >> /etc/pam.d/sshd
    echo -e '#userlimit' >> /etc/pam.d/sshd
    echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi

if  grep -Fxq "auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi

printf '\n'


