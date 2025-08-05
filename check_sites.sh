#!/bin/bash

# List of target websites to check
TARGET_SITES=(
    "https://www.snapchat.com"
    "https://gemini.google.com"
    "https://chat.openai.com"
    "https://www.instagram.com"
    "https://www.tiktok.com"
    "https://www.reddit.com"
)

# Color functions
green()  { echo -e "\e[32m$1\e[0m"; }
red()    { echo -e "\e[31m$1\e[0m"; }
yellow() { echo -e "\e[33m$1\e[0m"; }

# Loop through each site
for URL in "${TARGET_SITES[@]}"; do
    HOST=$(echo "$URL" | awk -F/ '{print $3}')
    
    echo "======================================"
    echo "🔍 Checking $URL"

    # DNS resolution
    if getent hosts "$HOST" > /dev/null; then
        green "✔ DNS resolved for $HOST"
    else
        red "✘ DNS resolution failed for $HOST"
        continue
    fi

    # Ping
    if ping -c 1 -W 2 "$HOST" > /dev/null 2>&1; then
        green "✔ Ping OK to $HOST"
    else
        yellow "⚠ Ping failed to $HOST (might be blocked or disabled)"
    fi

    # TCP check port 443
    if timeout 3 bash -c "echo > /dev/tcp/$HOST/443" 2>/dev/null; then
        green "✔ TCP port 443 is open on $HOST"
    else
        red "✘ TCP port 443 is closed or unreachable on $HOST"
    fi

    # TLS handshake check using openssl
    echo | openssl s_client -servername "$HOST" -connect "$HOST:443" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        green "✔ TLS handshake successful with $HOST"
    else
        red "✘ TLS handshake failed with $HOST"
    fi

    # Curl with default user-agent
    CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL")
    if [[ "$CODE" == "200" || "$CODE" == "301" || "$CODE" == "302" ]]; then
        green "✔ HTTP status: $CODE (Normal access)"
    elif [[ "$CODE" == "403" ]]; then
        red "✘ HTTP 403 Forbidden - IP might be blocked"
    elif [[ "$CODE" == "000" ]]; then
        red "✘ HTTP request failed (timeout or blocked)"
    else
        yellow "⚠ HTTP status code: $CODE (unexpected)"
    fi

    # Curl with mobile User-Agent
    MOBILE_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 -A "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148" "$URL")
    if [[ "$MOBILE_CODE" == "200" || "$MOBILE_CODE" == "301" || "$MOBILE_CODE" == "302" ]]; then
        green "✔ Mobile HTTP access OK: $MOBILE_CODE"
    elif [[ "$MOBILE_CODE" == "403" ]]; then
        red "✘ Mobile HTTP 403 Forbidden - likely blocked on mobile client"
    else
        yellow "⚠ Mobile HTTP access failed or abnormal: $MOBILE_CODE"
    fi

    echo ""
done
