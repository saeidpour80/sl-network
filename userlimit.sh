#! /bin/bash

clear

Color_Off='\033[0m'       # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

echo -e "${Red}@@@@@@@@@@${Color_Off}${Blue}@@@@@@@@@@${Color_Off}${White}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${Color_Off}
${Red}@@@@@@@@@@${Color_Off}${Blue}@@@@@@@@@@${Color_Off}${White}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${Color_Off}
${Red}@@@&GG#&@@${Color_Off}${Blue}@@@#!!P@@@${Color_Off}${White}@@@&&&&@@@&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P7!#@@@@@@@${Color_Off}
${Red}@G.     &@${Color_Off}${Blue}@@@P  !@@@${Color_Off}${White}@@&    #@@7  7@@@@@@@@@@@@@@##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@!  P@@@@@@@${Color_Off}
${Red}&   !##P&@${Color_Off}${Blue}@@@P  7@@@${Color_Off}${White}@@&    .&@!  !@@@@@@@@@@@@@P  7@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@7  P@@@@@@@${Color_Off}
${Red}@.  .5@@@@${Color_Off}${Blue}@@@P  7@@@${Color_Off}${White}@@&     .&7  7@@@#! ..^5@@?     @^..&@Y..B@G. J@@?.   ^B@@@...P: &@7  G@?. :#@${Color_Off}
${Red}@@J.   J@@${Color_Off}${Blue}@@@P  7@@@${Color_Off}${White}@@&   5  .~  7@@&  .#Y  J@G^  .?@B  !@   ^@.  &@:  ?P.  B@@   .7?@@7  ?^  ~&@@${Color_Off}
${Red}@@@@G.  ~@${Color_Off}${Blue}@@@P  7@@@${Color_Off}${White}@@&   &B     7@@P  .!~...@@G  7@@@!  J ^  ?  G@&   @@G  !@@   #@@@@7  .  .@@@@${Color_Off}
${Red}@5YBB.  .@${Color_Off}${Blue}@@@P  !@@@${Color_Off}${White}@@&   &@B    !@@&  .&&YYB@@P  !@@@@    #Y   ^@@@.  P#~  5@@   &@@@@!  PY  ^&@@${Color_Off}
${Red}@?    .!&@${Color_Off}${Blue}@@@G  7@@@${Color_Off}${White}@@&   &@@P   7@@@G. .. !&@@G  7@@@@P  ^@@   &@@@&^    .J@@@   &@@@@7  G@5  :&@${Color_Off}
${Red}@@&##&@@@@${Color_Off}${Blue}@@@@&&@@@@${Color_Off}${White}@@@&&&@@@@&&&@@@@@@&##@@@@@@&&@@@@@@&&@@@@&&@@@@@@&##&@@@@@&&&@@@@@@&&@@@&&&&@${Color_Off}
${Red}@@@@@@@@@@${Color_Off}${Blue}@@@@@@@@@@${Color_Off}${White}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${Color_Off}
${Red}@@@@@@@@@@${Color_Off}${Blue}@@@@@@@@@@${Color_Off}${White}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${Color_Off}
${Red}@@@@@@@@@@${Color_Off}${Blue}@@@@@@@@@@${Color_Off}${White}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${Color_Off}"
printf "\n\n"
echo -e "${Purple}1) User connection limit${Color_Off}\n"
echo -e "${Cyan}2) User connection limit + User expiration date${Color_Off}\n"
echo -e "${Purple}3) User connection limit + Set expiration date after first connection${Color_Off}\n"
echo -e "${Cyan}4) User connection limit + User expiration date + Set expiration date after first connection${Color_Off}\n"
echo -e "${Red}5) Remove script${Color_Off}\n"
echo -e "${Yellow}6) Exit${Color_Off}\n"
printf "\n"
printf "${White}Choose one of the options : ${Color_Off}"
read op
while [[ -z "$op" ]] || [[ !("$op" =~ ^[0-9]+$) ]]
do
    echo -e "\n${Red}Invalid value, Try again${Color_Off}"
    printf "${White}Choose one of the options : ${Color_Off}"
    read op
done
if [[ $op -eq 1 ]] || [[ $op -eq 3 ]]
then
    printf "\n${White}Number of connections per user : ${Color_Off}"
    read noc
    while [[ -z "$noc" ]] || [[ !("$noc" =~ ^[0-9]+$) ]]
    do
        echo -e "\n${Red}Invalid value, Try again${Color_Off}"
        printf "${White}Number of connections per user : ${Color_Off}"
        read noc
    done
    { rm /etc/userlimit; } &> /dev/null
    echo '#! /bin/bash' >> /etc/userlimit
    echo '' >> /etc/userlimit
    if [[ $op -eq 3 ]]
    then
        printf "\n${White}Set the expiration date for how many days after the first connection ? : ${Color_Off}"
        read edafc
        while [[ -z "$edafc" ]] || [[ !("$edafc" =~ ^[0-9]+$) ]]
        do
            echo -e "\n${Red}Invalid value, Try again${Color_Off}"
            printf "${White}Set the expiration date for how many days after the first connection ? : ${Color_Off}"
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
    echo -e "\n${Green}Successful${Color_Off}"
elif [[ $op -eq 2 ]] || [[ $op -eq 4 ]]
then
    printf "\n${White}Number of connections per user : ${Color_Off}"
    read noc
    while [[ -z "$noc" ]] || [[ !("$noc" =~ ^[0-9]+$) ]]
    do
        echo -e "\n${Red}Invalid value, Try again${Color_Off}"
        printf "${White}Number of connections per user : ${Color_Off}"
        read noc
    done
    timedatectl set-timezone Asia/Tehran
    { rm /etc/userlimit; } &> /dev/null
    echo '#! /bin/bash' >> /etc/userlimit
    echo '' >> /etc/userlimit
    if [[ $op -eq 4 ]]
    then
        printf "\n${White}Set the expiration date for how many days after the first connection ? : ${Color_Off}"
        read edafc
        while [[ -z "$edafc" ]] || [[ !("$edafc" =~ ^[0-9]+$) ]]
        do
            echo -e "\n${Red}Invalid value, Try again${Color_Off}"
            printf "${White}Set the expiration date for how many days after the first connection ? : ${Color_Off}"
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
    echo -e "\n${Green}Successful${Color_Off}"
elif [[ $op -eq 5 ]]
then
    printf "\n${Red}Are you sure you want to remove the script ? (y/n): ${Color_Off}"
    read rs
    while [[ -z "$rs" ]] || [[ !("$rs" =~ ^[nNyY]+$) ]] || [[ ${#rs} -gt 1 ]]
    do
        echo -e "\n${Red}Invalid value, Try again${Color_Off}"
        printf "${Red}Are you sure you want to remove the script ? (y/n): ${Color_Off}"
        read rs
    done
    lowerrs=$(echo "$rs" | tr '[:upper:]' '[:lower:]')
    if [[ "$lowerrs" == "y" ]]
    then
        { rm /etc/userlimit; } &> /dev/null
        sed -i '/#userlimit/d' /etc/pam.d/sshd
        sed -i '/account    required     pam_exec.so /etc/userlimit/d' /etc/pam.d/sshd
        sed -i '/auth       required     pam_exec.so /etc/userlimit\n/d' /etc/pam.d/sshd
#         grep -v "^#userlimit
# account    required     pam_exec.so /etc/userlimit
# auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd > /tmp/ul && mv /tmp/ul /etc/pam.d/sshd
#         { rm /tmp/ul; } &> /dev/null
        echo -e "\n${Green}The script was successfully removed${Color_Off}\n"
        exit 1
    else
        printf '\n'
        exit 1
    fi
else
    printf '\n'
    exit 1
fi

{ chmod -v +x /etc/userlimit; } &> /dev/null

if  grep -Fxq "#userlimit" /etc/pam.d/sshd
then
    :
else
    sed -i '/@include common-password/d' /etc/pam.d/sshd
    sed -i '$d' /etc/pam.d/sshd
    echo -e '#userlimit' >> /etc/pam.d/sshd
    echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
    echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
    echo '' >> /etc/pam.d/sshd
    echo '# Standard Un*x password updating.' >> /etc/pam.d/sshd
    echo '@include common-password' >> /etc/pam.d/sshd
fi

printf '\n'
