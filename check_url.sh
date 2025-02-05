#!/bin/bash

# توابع برای چاپ رنگی
print_success() {
    echo -e "\e[32m$1\e[0m"  # سبز
}

print_error() {
    echo -e "\e[31m$1\e[0m"  # قرمز
}

# دریافت ورودی از کاربر
while true; do
    read -p "Enter the URL to check: " USER_URL
    
    if [[ -z "$USER_URL" ]]; then
        print_error "URL cannot be empty. Please enter a valid URL."
    else
        break
    fi
done

# مرحله 1: پینگ کردن سرور
echo "Pinging ${USER_URL}..."
if ping -c 1 $(echo $USER_URL | awk -F/ '{print $3}') > /dev/null 2>&1; then
    print_success "Ping successful for ${USER_URL}!"
else
    print_error "Ping failed for ${USER_URL}. You cannot reach the server."
    exit 1
fi

# مرحله 2: تست HTTP
echo "Testing HTTP access for ${USER_URL}..."
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "$USER_URL")

if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
    print_success "HTTP access successful for ${USER_URL}!"
else
    print_error "HTTP access failed for ${USER_URL} with response code: $HTTP_RESPONSE"
    exit 1
fi
