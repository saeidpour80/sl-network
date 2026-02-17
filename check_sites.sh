#!/bin/bash

# Final VPN + Streaming/Spotify Check Script
# Optimized for speed, no long traceroute hangs
# Run: bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/main/check_sites.sh)

TARGET_SITES=(
    "https://www.snapchat.com"
    "https://gemini.google.com"
    "https://chat.openai.com"
    "https://www.instagram.com"
    "https://www.tiktok.com"
    "https://www.reddit.com"

    # Spotify
    "https://open.spotify.com"
    "https://api.spotify.com"
    "https://spclient.wg.spotify.com"
    "https://apresolve.spotify.com"
    "https://spotify.com"
)

# Colors
green()  { echo -e "\e[32m$1\e[0m"; }
red()    { echo -e "\e[31m$1\e[0m"; }
yellow() { echo -e "\e[33m$1\e[0m"; }

is_success_code() {
    [[ "$1" =~ ^2[0-9][0-9]$ || "$1" =~ ^3[0-9][0-9]$ ]]
}

check_dns() {
    local host="$1"
    if getent hosts "$host" > /dev/null; then
        green "✔ DNS resolved for $host"
        return 0
    else
        red "✘ DNS resolution failed for $host"
        return 1
    fi
}

check_ping() {
    local host="$1"
    if ping -c 1 -W 1 "$host" > /dev/null 2>&1; then
        green "✔ Ping OK to $host"
    else
        yellow "⚠ Ping failed to $host (ICMP may be blocked)"
    fi
}

check_tcp_port() {
    local host="$1"
    local port="$2"
    if command -v nc >/dev/null 2>&1; then
        if timeout 2 nc -z "$host" "$port" >/dev/null 2>&1; then
            green "✔ TCP $port open on $host"
        else
            yellow "⚠ TCP $port filtered/closed on $host"
        fi
    else
        if timeout 2 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
            green "✔ TCP $port open on $host"
        else
            yellow "⚠ TCP $port filtered/closed on $host"
        fi
    fi
}

check_tls() {
    local host="$1"
    echo | openssl s_client -servername "$host" -connect "$host:443" -brief > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        green "✔ TLS OK for $host"
    else
        red "✘ TLS failed for $host"
    fi
}

check_http() {
    local url="$1"
    local ua="Mozilla/5.0 Chrome"
    local code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -A "$ua" "$url")
    if is_success_code "$code"; then
        green "✔ HTTP OK ($code) $url"
    else
        yellow "⚠ HTTP $code $url"
    fi
}

check_mobile_http() {
    local url="$1"
    local ua="Mozilla/5.0 iPhone"
    local code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -A "$ua" "$url")
    if is_success_code "$code"; then
        green "✔ Mobile HTTP OK ($code) $url"
    else
        yellow "⚠ Mobile HTTP $code $url"
    fi
}

check_spclient() {
    local code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 https://spclient.wg.spotify.com)
    if is_success_code "$code"; then
        green "✔ Spotify core OK ($code)"
    else
        red "✘ Spotify core issue ($code)"
    fi
}

# Fast traceroute only when needed
do_traceroute() {
    local host="$1"
    local failed="$2"
    [ "${failed:-0}" -eq 0 ] && return

    if command -v tracepath >/dev/null 2>&1; then
        yellow "→ Fast tracepath (4 hops)"
        tracepath -m 4 "$host" 2>/dev/null || true
        return
    fi

    if command -v traceroute >/dev/null 2>&1; then
        yellow "→ Fast traceroute (4 hops, 1 probe, 1s)"
        traceroute -m 4 -q 1 -w 1 "$host" 2>/dev/null || true
        return
    fi
}

# MAIN
for URL in "${TARGET_SITES[@]}"; do
    HOST=$(echo "$URL" | awk -F/ '{print $3}')
    echo "======================================"
    echo "🔍 Checking $URL"

    check_dns "$HOST"; dns=$?
    check_ping "$HOST"
    check_tcp_port "$HOST" 443
    check_tcp_port "$HOST" 80
    check_tls "$HOST"
    check_http "$URL"; http=$?
    check_mobile_http "$URL"

    [[ "$HOST" == *"spotify"* ]] && check_spclient

    do_traceroute "$HOST" $http
    echo
done

echo "✅ Test Complete"
echo "If Spotify app still fails: log out, clear cache, re-login."
