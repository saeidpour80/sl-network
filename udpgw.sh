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
udpport=7300
echo -e "${White}Default udpgw port is ${Color_Off}${Green}$udpport${Color_Off}"
printf "${White}If you need to change it, Enter your desired port : ${Color_Off}"
read udpport
while [[ !( -z "$udpport" ) ]] && [[ !("$udpport" =~ ^[0-9]+$) ]]
do  
    echo -e "\n${Red}Invalid value, Try again${Color_Off}"
    echo -e "${White}Default udpgw port is ${Color_Off}${Green}7300${Color_Off}"
    printf "${White}If you need to change it, Enter your desired port : ${Color_Off}"
    read udpport
done

if [[ -z "$udpport" ]]
then
    udpport=7300
fi

if command -v ufw > /dev/null 2>&1; then
    ufw allow $udpport
fi

apt update -y
apt install git cmake -y
git clone https://github.com/ambrop72/badvpn.git /root/badvpn
mkdir /root/badvpn/badvpn-build
cd  /root/badvpn/badvpn-build
cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 &
wait
make &
wait
cp udpgw/badvpn-udpgw /usr/local/bin
cat >  /etc/systemd/system/videocall.service << ENDOFFILE
[Unit]
Description=UDP forwarding for badvpn-tun2socks
After=nss-lookup.target

[Service]
ExecStart=/usr/local/bin/badvpn-udpgw --loglevel none --listen-addr 127.0.0.1:$udpport --max-clients 999
User=videocall

[Install]
WantedBy=multi-user.target
ENDOFFILE
useradd -m videocall
systemctl enable videocall
systemctl start videocall
