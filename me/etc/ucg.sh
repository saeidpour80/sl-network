#! /bin/bash

echo "Username :"
read username
echo "Destination Group :"
read group

ug=$(groups "$username")
currentusersgroup=${ug#*: }

usermod -g "$group" "$username"
sleep .5
deluser "$username" "$currentusersgroup"
sleep .5
adduser "$username" "$group"

vpn1user=$(getent group vpn1user)
vpn2user=$(getent group vpn2user)
vpn3user=$(getent group vpn3user)
vpn4user=$(getent group vpn4user)

IFS=':'
read -ra v1u <<< "$vpn1user"
read -ra v2u <<< "$vpn2user"
read -ra v3u <<< "$vpn3user"
read -ra v4u <<< "$vpn4user"

v1u_u=${v1u[3]}
v2u_u=${v2u[3]}
v3u_u=${v3u[3]}
v4u_u=${v4u[3]}

IFS=','
read -ra v1u_users <<< "$v1u_u"
read -ra v2u_users <<< "$v2u_u"
read -ra v3u_users <<< "$v3u_u"
read -ra v4u_users <<< "$v4u_u"

echo ""
echo "---------------------------------------------------------"
echo "------------------------vpn1user-------------------------"
while [[ $i -lt ${#v1u_users[@]} ]]
do
    getname=$(getent passwd "${v1u_users[$i]}")
    IFS=':'
    read -ra gname <<< "$getname"
    printf '%-26s---------> %s\n' "${v1u_users[$i]}" "${gname[4]}"
    i=$(($i + 1))
done
echo ""
echo "---------------------------------------------------------"
echo "------------------------vpn2user-------------------------"
while [[ $i -lt ${#v2u_users[@]} ]]
do
    getname=$(getent passwd "${v2u_users[$i]}")
    IFS=':'
    read -ra gname <<< "$getname"
    printf '%-26s---------> %s\n' "${v2u_users[$i]}" "${gname[4]}"
    i=$(($i + 1))
done
echo ""
echo "---------------------------------------------------------"
echo "------------------------vpn3user-------------------------"
while [[ $i -lt ${#v3u_users[@]} ]]
do
    getname=$(getent passwd "${v3u_users[$i]}")
    IFS=':'
    read -ra gname <<< "$getname"
    printf '%-26s---------> %s\n' "${v3u_users[$i]}" "${gname[4]}"
    i=$(($i + 1))
done
echo ""
echo "---------------------------------------------------------"
echo "------------------------vpn4user-------------------------"
while [[ $i -lt ${#v4u_users[@]} ]]
do
    getname=$(getent passwd "${v4u_users[$i]}")
    IFS=':'
    read -ra gname <<< "$getname"
    printf '%-26s---------> %s\n' "${v4u_users[$i]}" "${gname[4]}"
    i=$(($i + 1))
done
echo ""
