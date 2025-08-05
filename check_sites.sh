#!/bin/bash

TARGET_SITES=(
    "https://www.snapchat.com"
    "https://gemini.google.com"
    "https://chat.openai.com"
    "https://www.instagram.com"
    "https://www.tiktok.com"
    "https://www.reddit.com"
)

# Colors
green()  { echo -e "\e[32m$1\e[0m"; }
red()    { echo -e "\e[31m$1\e[0m"; }
yellow() { echo -e "\e[33m$1\e[0m"; }

is_success_code() {
    [[ "$1" =~ ^2[0-9][0-9]$ || "$1" =~ ^3[0-9][0-9]$ ]]
}

for URL in "${TARGET_SITES[@]}"; do
    HOST=$(echo "$URL" | awk -F/ '{print $3}')

    echo "======================================"
    echo "🔍 Checking $URL"

    # DNS
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
        yellow "⚠ Ping failed to $HOST (may be normal)"
    fi

    # TCP
    if timeout 3 bash -c "echo > /dev/tcp/$HOST/443" 2>/dev/null; then
        green "✔ TCP port 443 is open on $HOST"
    else
        yellow "⚠ TCP port 443 appears closed (or filtered)"
    fi

    # TLS
    echo | openssl s_client -servername "$HOST" -connect "$HOST:443" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        green "✔ TLS handshake successful with $HOST"
    else
        red "✘ TLS handshake failed with $HOST"
    fi

    # HTTP status
    CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL")
    if is_success_code "$CODE"; then
        green "✔ HTTP access OK (code $CODE)"
    elif [[ "$CODE" == "403" ]]; then
        red "✘ HTTP 403 Forbidden - IP may be blocked"
    elif [[ "$CODE" == "000" ]]; then
        red "✘ HTTP request failed (timeout or blocked)"
    else
        yellow "⚠ HTTP status code: $CODE (non-standard)"
    fi

    # Mobile User-Agent
    MOBILE_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 \
        -A "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148" "$URL")

    if is_success_code "$MOBILE_CODE"; then
        green "✔ Mobile HTTP access OK (code $MOBILE_CODE)"
    elif [[ "$MOBILE_CODE" == "403" ]]; then
        red "✘ Mobile HTTP 403 Forbidden - likely IP is blocked"
    else
        yellow "⚠ Mobile HTTP status: $MOBILE_CODE (non-standard)"
    fi

    echo ""
done
