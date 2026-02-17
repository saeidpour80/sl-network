#!/bin/bash

# COLORS
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}   Advanced Service Availability Checker      ${NC}"
echo -e "${BLUE}==============================================${NC}"

# User Agent واقعی برای دور زدن برخی محدودیت‌های ربات
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

check_service() {
    local name=$1
    local url=$2
    local search_str=$3 # کلمه‌ای که اگر در متن باشد یعنی "بلاک" شده‌ایم
    
    echo -n -e "Checking $name... "
    
    # دریافت محتوا و کد وضعیت
    local response=$(curl -s -L -A "$UA" --max-time 10 "$url")
    local code=$(curl -s -L -o /dev/null -w "%{http_code}" -A "$UA" --max-time 10 "$url")

    if [[ "$code" == "403" || "$code" == "401" ]]; then
        echo -e "${RED}✘ Blocked (HTTP $code)${NC}"
    elif [[ -n "$search_str" && "$response" == *"$search_str"* ]]; then
        echo -e "${RED}✘ Restricted (Region Blocked)${NC}"
    elif [[ "$code" == "200" || "$code" == "302" ]]; then
        echo -e "${GREEN}✔ Available${NC}"
    else
        echo -e "${YELLOW}⚠ Unknown (HTTP $code)${NC}"
    fi
}

# 1. تست اختصاصی Gemini (بررسی منطقه جغرافیایی)
check_gemini() {
    echo -n -e "Checking Gemini... "
    # گوگل اگر آی‌پی دیتاسنتر یا ایران باشد، در پاسخ کلمه "not available" یا ریدایرکت به صفحه خطا دارد
    local resp=$(curl -s -L -A "$UA" "https://gemini.google.com/app")
    if [[ "$resp" == *"is not currently supported"* || "$resp" == *"isn't available"* ]]; then
        echo -e "${RED}✘ Restricted (Not available in your country)${NC}"
    else
        echo -e "${GREEN}✔ Available${NC}"
    fi
}

# 2. تست اختصاصی OpenAI (ChatGPT)
check_openai() {
    echo -n -e "Checking ChatGPT... "
    # OpenAI معمولاً روی آی‌پی‌های دیتاسنتر کد 403 یا صفحه Cloudflare Access Denied می‌دهد
    local code=$(curl -s -o /dev/null -w "%{http_code}" -A "$UA" "https://chatgpt.com")
    if [[ "$code" == "403" ]]; then
        echo -e "${RED}✘ Blocked (Cloudflare/Access Denied)${NC}"
    else
        echo -e "${GREEN}✔ Available${NC}"
    fi
}

# 3. تست اختصاصی Spotify
check_spotify() {
    echo -n -e "Checking Spotify... "
    # بررسی اندپوینت اصلی کلاینت اسپاتیفای
    local code=$(curl -s -o /dev/null -w "%{http_code}" "https://spclient.wg.spotify.com/signup/v1/check-parameters")
    if [[ "$code" == "200" || "$code" == "405" ]]; then # 405 هم یعنی اندپوینت زنده است
        echo -e "${GREEN}✔ Available${NC}"
    else
        echo -e "${RED}✘ Blocked/Issue ($code)${NC}"
    fi
}

# --- شروع اجرای تست‌ها ---

# سرویس‌های ساده با بررسی کلمات کلیدی بلاک
check_service "Snapchat" "https://www.snapchat.com" "denied"
check_gemini
check_openai
check_service "TikTok" "https://www.tiktok.com" "not available"
check_service "Instagram" "https://www.instagram.com" "login"
check_service "Reddit" "https://www.reddit.com" "blocked"
check_spotify

# بررسی کلی لوکیشن آی‌پی برای اطمینان
echo -e "${BLUE}----------------------------------------------${NC}"
IP_COUNTRY=$(curl -s https://ipinfo.io/country)
IP_ORG=$(curl -s https://ipinfo.io/org)
echo -e "Server IP Country: ${YELLOW}$IP_COUNTRY${NC}"
echo -e "ISP/Org: ${YELLOW}$IP_ORG${NC}"

echo -e "${BLUE}==============================================${NC}"
echo -e "✅ Test Complete."
