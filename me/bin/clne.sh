#! /bin/bash

ZONE_ID="0708fff580c96ee2a6a43f1c30dead34"
CF_BEARER="YEP9EVr7_LrgYwyDSxDbYkmjYZyXKiRrmd0TK6V7"
IP=$(hostname -I | awk '{print $1}')

A_record="s1.sl-network.net"
A_record_id="6b7b03d301a1200352de0b6f636f210e"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$A_record_id" \
    -H "Authorization: Bearer $CF_BEARER" \
    -H "Content-Type: application/json" \
    --data "{
        \"content\": \"$IP\",
        \"name\": \"$A_record\",
        \"proxied\": false,
        \"type\": \"A\",
        \"comment\": \"Netherlands (Amsterdam)\",
        \"ttl\": 1
    }"

sleep 5

A_record="sne1s.sl-network.net"
A_record_id="da52c7ded9b90ab23076a56b9d49bf1f"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$A_record_id" \
    -H "Authorization: Bearer $CF_BEARER" \
    -H "Content-Type: application/json" \
    --data "{
        \"content\": \"$IP\",
        \"name\": \"$A_record\",
        \"proxied\": false,
        \"type\": \"A\",
        \"comment\": \"Netherlands (Amsterdam)\",
        \"ttl\": 1
    }"



# curl https://api.cloudflare.com/client/v4/zones/$ZONE_ID \
#     -H "Authorization: Bearer $CF_BEARER"