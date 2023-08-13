# Sl Network

تعریف محدودیت برای اتصال همزمان به ازای هر کاربر :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/userlimit.sh --ipv4)
```
شامل دو گزینه است :<br>
1 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر<br>
2 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس (Account expires توسط دستور chage یا usermod)<br>
