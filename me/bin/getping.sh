#! /bin/bash

BOT_TOKEN="6740027708:AAHFst9deCikTbscLts8b6ff24dcuhAYrzg"
CHAT_ID="159313886"
SERVER_NAME="S1"
send_message() {
 local message="$1"
 curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
 -d "chat_id=$CHAT_ID" \
 -d "text=$message"
}

myip=$(hostname -I | awk '{print $1}')

ping_check_request_id=$(curl -H "Accept: application/json" "https://check-host.net/check-ping?host=$myip" | awk -F '"request_id":"' '{print $2}' | awk -F '"}' '{print $1}')

sleep 15

ir1_ping_check_results=$(curl -H "Accept: application/json" "https://check-host.net/check-result/$ping_check_request_id" | awk -F '"ir1.node.check-host.net":[][{}][][{}]' '{print $2}' | awk -F ']],"' '{print $1}')
ir3_ping_check_results=$(curl -H "Accept: application/json" "https://check-host.net/check-result/$ping_check_request_id" | awk -F '"ir3.node.check-host.net":[][{}][][{}]' '{print $2}' | awk -F ']],"' '{print $1}')
ir5_ping_check_results=$(curl -H "Accept: application/json" "https://check-host.net/check-result/$ping_check_request_id" | awk -F '"ir5.node.check-host.net":[][{}][][{}]' '{print $2}' | awk -F ']],"' '{print $1}')
ir6_ping_check_results=$(curl -H "Accept: application/json" "https://check-host.net/check-result/$ping_check_request_id" | awk -F '"ir6.node.check-host.net":[][{}][][{}]' '{print $2}' | awk -F ']],"' '{print $1}')

ir1=0
ir3=0
ir5=0
ir7=0

IFS=',' read -ra ADDR <<< "$ir1_ping_check_results"

if [[ ${ADDR[0]} == '["OK"' ]] && [[ ${ADDR[3]} == '["OK"' ]] && [[ ${ADDR[5]} == '["OK"' ]] && [[ ${ADDR[7]} == '["OK"' ]]
then
    ir1=1
else
    ir1=0
fi

IFS=',' read -ra ADDR <<< "$ir3_ping_check_results"

if [[ ${ADDR[0]} == '["OK"' ]] && [[ ${ADDR[3]} == '["OK"' ]] && [[ ${ADDR[5]} == '["OK"' ]] && [[ ${ADDR[7]} == '["OK"' ]]
then
    ir3=1
else
    ir3=0
fi

IFS=',' read -ra ADDR <<< "$ir5_ping_check_results"

if [[ ${ADDR[0]} == '["OK"' ]] && [[ ${ADDR[3]} == '["OK"' ]] && [[ ${ADDR[5]} == '["OK"' ]] && [[ ${ADDR[7]} == '["OK"' ]]
then
    ir5=1
else
    ir5=0
fi

IFS=',' read -ra ADDR <<< "$ir6_ping_check_results"

if [[ ${ADDR[0]} == '["OK"' ]] && [[ ${ADDR[3]} == '["OK"' ]] && [[ ${ADDR[5]} == '["OK"' ]] && [[ ${ADDR[7]} == '["OK"' ]]
then
    ir6=1
else
    ir6=0
fi

clear

if [[ $ir1 -eq 1 ]] && [[ $ir3 -eq 1 ]] && [[ $ir5 -eq 1 ]] && [[ $ir6 -eq 1 ]]
then
    clne.sh
    echo ""
    echo ""
    echo "Server ($SERVER_NAME) Is OK In Iran"
else
    hour=$(date "+%H")
    if [[ ${hour#0} -ge 2 && ${hour#0} -le 8 ]]
    then
        clir.sh
    fi
    echo ""
    echo ""
    echo "Server ($SERVER_NAME) Is Not OK In Iran !!!"
    echo ""
    echo ""
    send_message "Server ($SERVER_NAME) Is Not OK In Iran !!!"
fi
