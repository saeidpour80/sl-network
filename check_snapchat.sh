#!/bin/bash

# آدرس‌های سرور اسنپ‌چت
SNAPCHAT_URLS=("https://www.snapchat.com" "https://accounts.snapchat.com")

# توابع برای چاپ رنگی
print_success() {
    echo -e "\e[32m$1\e[0m"  # سبز
}

print_error() {
    echo -e "\e[31m$1\e[0m"  # قرمز
}

# بررسی هر URL
for SNAPCHAT_URL in "${SNAPCHAT_URLS[@]}"; do
    # مرحله 1: پینگ کردن سرور
    echo "Pinging ${SNAPCHAT_URL}..."
    if ping -c 1 $(echo $SNAPCHAT_URL | awk -F/ '{print $3}') > /dev/null 2>&1; then
        print_success "Ping successful for ${SNAPCHAT_URL}!"
    else
        print_error "Ping failed for ${SNAPCHAT_URL}. You cannot reach the server."
        continue  # ادامه به URL بعدی
    fi

    # مرحله 2: تست HTTP
    echo "Testing HTTP access for ${SNAPCHAT_URL}..."
    HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$SNAPCHAT_URL")

    if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
        print_success "HTTP access successful for ${SNAPCHAT_URL}!"
    else
        print_error "HTTP access failed for ${SNAPCHAT_URL} with response code: $HTTP_RESPONSE"
        continue  # ادامه به URL بعدی
    fi

    # مرحله 3: بررسی دیگر وضعیت‌ها
    echo "Checking additional HTTP responses for ${SNAPCHAT_URL}..."
    HTTP_DETAIL=$(curl -s -I "$SNAPCHAT_URL")

    if echo "$HTTP_DETAIL" | grep -q "200 OK"; then
        print_success "You are likely able to use Snapchat with this VPN through ${SNAPCHAT_URL}."
    else
        print_error "There may be restrictions on using Snapchat with this VPN through ${SNAPCHAT_URL}."
    fi
done

echo -e "\nAll checks completed."
