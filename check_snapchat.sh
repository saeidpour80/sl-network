#!/bin/bash

# Snapchat domain addresses for testing
domains=("app.snapchat.com" "feelinsonice-hrd.appspot.com" "app-analytics.snapchat.com")

# Checking ping status
echo "Checking connectivity to Snapchat servers..."
for domain in "${domains[@]}"
do
    echo "Pinging $domain..."
    ping -c 4 $domain &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "Ping to $domain was successful."
    else
        echo "Ping to $domain failed. Your IP might be blocked."
    fi
done

# Checking HTTP status using curl
echo -e "\nChecking HTTP response status..."
for domain in "${domains[@]}"
do
    echo "Checking HTTP status for $domain..."
    response=$(curl -s -o /dev/null -w "%{http_code}" https://$domain)
    
    if [ $response -eq 200 ]; then
        echo "HTTP request to $domain was successful (Status: 200)."
    else
        echo "HTTP request to $domain failed (HTTP status code: $response)."
    fi
done
