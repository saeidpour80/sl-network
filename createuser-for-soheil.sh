#! /bin/bash

timedatectl set-timezone Asia/Tehran
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
echo -e "\n\n"
printf "${White}Username prefix : ${Color_Off}"
read up
while [[ -z "$up" ]] || [[ !("$up" =~ ^[a-z0-9]+$) ]] || [[ "$up" == *" "* ]] || [[ "$up" =~ ^[0-9] ]]
do
    printf "\n"
    if [[ -z "$up" ]]
    then
        echo -e "${Red}Username prefix cannot be empty, Try again${Color_Off}"
    fi
    if [[ !("$up" =~ ^[a-z0-9]+$) ]] || [[ "$up" == *" "* ]]
    then
        echo -e "${Red}Username prefix can only contain lowercase letters and numbers, Try again${Color_Off}"
    fi
    if [[ "$up" =~ ^[0-9] ]]
    then
        echo -e "${Red}Username prefix cannot start with a number, Try again${Color_Off}"
    fi
    printf "${White}Username prefix : ${Color_Off}"
    read up
done

printf "\n${White}Password : ${Color_Off}"
read pp
while [[ -z "$pp" ]] || [[ "$pp" == *" "* ]] || [[ "$pp" == *"-"* ]] || [[ "$pp" == *"_"* ]] || [[ "$pp" == *"@"* ]]
do
    printf "\n"
    if [[ -z "$pp" ]]
    then
        echo -e "${Red}Password cannot be empty, Try again${Color_Off}"
    fi
    if [[ "$pp" == *" "* ]]
    then
        echo -e "${Red}The Password cannot contain spaces, Try again${Color_Off}"
    fi
    if [[ "$pp" == *"-"* ]] || [[ "$pp" == *"_"* ]] || [[ "$pp" == *"@"* ]]
    then
        echo -e "${Red}The Password cannot contain these characters : -_@, Try again${Color_Off}"
    fi
    printf "${White}Password : ${Color_Off}"
    read pp
done

printf "\n${White}Number of users : ${Color_Off}"
read nou
while [[ -z "$nou" ]] || [[ !("$nou" =~ ^[0-9]+$) ]]
do
    echo -e "\n${Red}Invalid value, Try again${Color_Off}"
    printf "${White}Number of users : ${Color_Off}"
    read nou
done

echo ""
echo ""
echo -e "${Purple}------------------------------------------------------------${Color_Off}"
echo -e "${Purple}------------------------------------------------------------${Color_Off}"
for (( i=1; i<=$nou; i++ ))
do
    username=$(printf '%s-%02d' "$up" "$i")
    password=$(printf '%s' "$pp")
    printf "${Cyan}%-30s${Color_Off}${Yellow}%30s${Color_Off}\n" "Username : $username" "Password : $password"
    { addgroup  "$username"; } &> /dev/null
    useradd -c "$username" -g "$username" -M -p "$password" -s /bin/false "$username"
    { echo -e "$password\n$password" | passwd "$username"; } &> /dev/null
done
echo -e "${Purple}------------------------------------------------------------${Color_Off}"
echo -e "${Purple}------------------------------------------------------------${Color_Off}"
echo ""
echo ""

