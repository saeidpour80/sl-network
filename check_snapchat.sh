#!/bin/bash

# Snapchat domain addresses for testing
domains=("app.snapchat.com" "feelinsonice-hrd.appspot.com" "app-analytics.snapchat.com")

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color (reset color)

# Checking ping status
echo "Checking connectivity to Snapchat servers..."
for domain in "${domains[@]}"
do
    echo "Pinging $domain..."
    ping -c 4 $domain &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Ping to $domain was successful.${NC}"
    else
        echo -e "${RED}Ping to $domain failed. Your IP might be blocked.${NC}"
    fi
done

# Checking HTTP status using curl
echo -e "\nChecking HTTP response status..."
for domain in "${domains[@]}"
do
    echo "Checking HTTP status for $domain..."
    response=$(curl -s -o /dev/null -w "%{http_code}" https://$domain)
    
    if [ $response -eq 200 ]; then
        echo -e "${GREEN}HTTP request to $domain was successful (Status: 200).${NC}"
    else
        echo -e "${RED}HTTP request to $domain failed (HTTP status code: $response).${NC}"
    fi
done
