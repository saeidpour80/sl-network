#!/bin/bash

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   Stealth Connectivity Checker (v3.0)        ${NC}"
echo -e "${BLUE}==============================================${NC}"

# استفاده از هدرهای پیشرفته‌تر برای شبیه‌سازی دقیق مرورگر
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"

check_stealth() {
    local name=$1
    local url=$2
    local block_keyword=$3

    echo -n -e "Checking $name... "
    
    # استفاده از --compressed و هدرهای اضافی برای فریب دادن سیستم ضد ربات
    local response=$(curl -s -L -A "$UA" \
        -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" \
        -H "Accept-Language: en-US,en;q=0.5" \
        --compressed --max-time 10 "$url")

    if echo "$response" | grep -iq "$block_keyword"; then
        echo -e "${RED}✘ Restricted (Region Lock Detected)${NC}"
    else
        local code=$(curl -s -L -o /dev/null -w "%{http_code}" -A "$UA" --max-time 10 "$url")
        
        # در مورد چت‌جی‌پی‌تی و اینستاگرام، حتی کد 403 همیشه به معنی بلاک بودن آی‌پی نیست
        if [[ "$code" == "200" || "$code" == "302" || "$code" == "301" ]]; then
            echo -e "${GREEN}✔ Available${NC}"
        elif [[ "$code" == "403" && "$name" == "ChatGPT" ]]; then
            echo -e "${YELLOW}⚠ Possible (Cloudflare blocked Script, but Browser might work)${NC}"
        else
            echo -e "${RED}✘ Blocked/Error (HTTP $code)${NC}"
        fi
    fi
}

# --- تست‌ها ---

# جمنای: چک کردن متن اروری که در عکستان بود
check_stealth "Gemini" "https://gemini.google.com/" "supported in your country"

# چت‌جی‌پی‌تی: چک کردن نقطه انتهایی که کمتر حساس است
check_stealth "ChatGPT" "https://chatgpt.com/favicon.ico" "access denied"

# اینستاگرام: اینستاگرام روی دیتاسنتر خیلی حساس است، تست با یک زیرصفحه
check_stealth "Instagram" "https://www.instagram.com/robots.txt" "login"

# تیک‌تاک
check_stealth "TikTok" "https://www.tiktok.com/" "not available"

# اسپاتیفای (روش مستقیم)
echo -n -e "Checking Spotify... "
if curl -s -I --max-time 5 "https://api.spotify.com" | grep -q "HTTP"; then
    echo -e "${GREEN}✔ Available${NC}"
else
    echo -e "${RED}✘ Blocked${NC}"
fi

echo -e "${BLUE}----------------------------------------------${NC}"
echo -e "Your IP Country: ${YELLOW}$(curl -s https://ipinfo.io/country)${NC}"
echo -e "${BLUE}==============================================${NC}"
