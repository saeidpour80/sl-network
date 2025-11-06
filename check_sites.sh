#!/bin/bash

# vpn_site_checks_spotify.sh
# Enhanced connectivity checklist for common social apps + Spotify-specific endpoints.
# Usage: sudo bash vpn_site_checks_spotify.sh
# Requires: curl, openssl, getent, ping, timeout (coreutils), awk, traceroute/netcat (optional)

TARGET_SITES=(
    "https://www.snapchat.com"
    "https://gemini.google.com"
    "https://chat.openai.com"
    "https://www.instagram.com"
    "https://www.tiktok.com"
    "https://www.reddit.com"

    # Spotify-related endpoints (add/remove as needed)
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
    if ping -c 1 -W 2 "$host" > /dev/null 2>&1; then
        green "✔ Ping OK to $host"
    else
        yellow "⚠ Ping failed to $host (ICMP may be blocked)"
    fi
}

check_tcp_port() {
    local host="$1"
    local port="$2"
    # Prefer nc if available for more reliable detection
    if command -v nc >/dev/null 2>&1; then
        if timeout 3 nc -z "$host" "$port" >/dev/null 2>&1; then
            green "✔ TCP port $port is open on $host"
            return 0
        else
            yellow "⚠ TCP port $port appears closed (or filtered) on $host"
            return 1
        fi
    else
        # fallback to /dev/tcp (may behave differently)
        if timeout 3 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
            green "✔ TCP port $port is open on $host"
            return 0
        else
            yellow "⚠ TCP port $port appears closed (or filtered) on $host"
            return 1
        fi
    fi
}

check_tls() {
    local host="$1"
    # -brief TLS handshake check
    echo | openssl s_client -servername "$host" -connect "$host:443" -brief > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        green "✔ TLS handshake successful with $host"
    else
        red "✘ TLS handshake failed with $host"
    fi
}

check_http() {
    local url="$1"
    local ua="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117 Safari/537.36"
    local code
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 -A "$ua" "$url")

    if is_success_code "$code"; then
        green "✔ HTTP access OK (code $code) for $url"
    elif [[ "$code" == "403" ]]; then
        red "✘ HTTP 403 Forbidden for $url - IP may be blocked"
    elif [[ "$code" == "000" ]]; then
        red "✘ HTTP request failed for $url (timeout or blocked)"
    else
        yellow "⚠ HTTP status code: $code for $url"
    fi
}

check_mobile_http() {
    local url="$1"
    local ua="Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
    local code
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 -A "$ua" "$url")

    if is_success_code "$code"; then
        green "✔ Mobile HTTP access OK (code $code) for $url"
    elif [[ "$code" == "403" ]]; then
        red "✘ Mobile HTTP 403 Forbidden for $url - likely IP is blocked"
    else
        yellow "⚠ Mobile HTTP status: $code for $url"
    fi
}

# Spotify-specific quick API probe (checks reachability of the spclient endpoint)
check_spclient() {
    local url="https://spclient.wg.spotify.com"
    local code
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 8 "$url")
    if is_success_code "$code"; then
        green "✔ spclient.wg.spotify.com reachable (code $code)"
    else
        yellow "⚠ spclient.wg.spotify.com returned $code"
    fi
}

# Optional traceroute if present
do_traceroute() {
    local host="$1"
    if command -v traceroute >/dev/null 2>&1; then
        yellow "→ traceroute to $host (first 8 hops):"
        traceroute -m 8 "$host" || true
    elif command -v tracepath >/dev/null 2>&1; then
        yellow "→ tracepath to $host (first 8 hops):"
        tracepath "$host" || true
    fi
}

# Main loop
for URL in "${TARGET_SITES[@]}"; do
    HOST=$(echo "$URL" | awk -F/ '{print $3}')

    echo "======================================"
    echo "🔍 Checking $URL"

    # DNS
    if ! check_dns "$HOST"; then
        echo ""
        continue
    fi

    # Ping
    check_ping "$HOST"

    # Basic TCP checks (443 and 80)
    check_tcp_port "$HOST" 443
    check_tcp_port "$HOST" 80

    # TLS handshake
    check_tls "$HOST"

    # HTTP status
    check_http "$URL"

    # Mobile UA test
    check_mobile_http "$URL"

    # Spotify-specific probe for spclient
    if [[ "$HOST" == *"spotify"* || "$HOST" == "spclient.wg.spotify.com" ]]; then
        check_spclient
    fi

    # Optional traceroute to help spot where filtering occurs
    do_traceroute "$HOST"

    echo ""
done

# Summary tips for Spotify-specific failures
cat <<'TIPS'

TIPS if users report "Spotify not working" even though open.spotify.com loads:

- Ask users to log out and log back in, and restart the Spotify app.
- Clear app cache (Android: App settings -> Storage -> Clear cache).
- If Spotify shows region/country errors, the account's country may not match the VPN IP's country.
- Some Spotify functionality (Connect, streaming) relies on additional backends (spclient.wg.spotify.com, api.spotify.com). If those are blocked, the app can behave incorrectly.
- If you see repeated HTTP 403 from spotify endpoints, that often means Spotify is rejecting the VPN IP. In that case try a different exit IP.
- Collect the script's output from the user (especially DNS, TLS and HTTP codes) — this helps identify whether the issue is DNS, IP-blocking, or app-level.

TIPS
