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
printf "Username prefix : "
read up
while [[ -z "$up" ]] || [[ !("$up" =~ ^[a-z0-9]+$) ]] || [[ "$up" == *" "* ]] || [[ "$up" =~ ^[0-9] ]]
do
    if [[ -z "$up" ]]
    then
        echo "Username prefix cannot be empty, Try again"
    fi
    if [[ !("$up" =~ ^[a-z0-9]+$) ]] || [[ "$up" == *" "* ]]
    then
        echo "Username prefix can only contain lowercase letters and numbers, Try again"
    fi
    if [[ "$up" =~ ^[0-9] ]]
    then
        echo "Username prefix cannot start with a number, Try again"
    fi
    printf "Username prefix : "
    read up
done

printf "Password prefix : "
read pp
while [[ -z "$pp" ]] || [[ "$pp" == *" "* ]] || [[ "$pp" == *"-"* ]] || [[ "$pp" == *"_"* ]] || [[ "$pp" == *"@"* ]]
do
    if [[ -z "$pp" ]]
    then
        echo "Password prefix cannot be empty, Try again"
    fi
    if [[ "$pp" == *" "* ]]
    then
        echo "The Password prefix cannot contain spaces, Try again"
    fi
    if [[ "$pp" == *"-"* ]] || [[ "$pp" == *"_"* ]] || [[ "$pp" == *"@"* ]]
    then
        echo "The Password prefix cannot contain these characters : -_@, Try again"
    fi
    printf "Password prefix : "
    read pp
done

printf "Number of users : "
read nou
while [[ !( -z "$nou" ) ]] && [[ !("$nou" =~ ^[0-9]+$) ]]
do
    echo "Invalid value, Try again"
    printf "Number of users : "
    read nou
done

for (( i=1; i<=$nou; i++ ))
do
    username=$(printf '%s_%02d' "$up" "$i")
    Password=$(printf '%s%02d' "$pp" "$i")
    printf "Username : $username\tPassword : $Password\n"
    useradd -M -p "$password" -s /bin/false "$username"
    { echo -e "$password\n$password" | passwd "$username"; } &> /dev/null
done