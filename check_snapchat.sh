#!/bin/bash

# آدرس سرور اسنپ‌چت
SNAPCHAT_URL="https://app.snapchat.com"

# توابع برای چاپ رنگی
print_success() {
    echo -e "\e[32m$1\e[0m"  # سبز
}

print_error() {
    echo -e "\e[31m$1\e[0m"  # قرمز
}

# مرحله 1: پینگ کردن سرور
echo "Pinging Snapchat server..."
if ping -c 1 $(echo $SNAPCHAT_URL | awk -F/ '{print $3}') > /dev/null 2>&1; then
    print_success "Ping successful!"
else
    print_error "Ping failed. You cannot reach Snapchat server."
    exit 1
fi

# مرحله 2: تست HTTP
echo "Testing HTTP access..."
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $SNAPCHAT_URL)

if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
    print_success "HTTP access successful!"
else
    print_error "HTTP access failed with response code: $HTTP_RESPONSE"
    exit 1
fi

# مرحله 3: بررسی دیگر وضعیت‌ها
echo "Checking additional HTTP responses..."
HTTP_DETAIL=$(curl -s -I $SNAPCHAT_URL)

if echo "$HTTP_DETAIL" | grep -q "200 OK"; then
    print_success "You are likely able to use Snapchat with this VPN."
else
    print_error "There may be restrictions on using Snapchat with this VPN."
    exit 1
fi

echo -e "\nAll checks completed."
