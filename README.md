# Sl Network
:green_circle: <b>تست شده روی ubuntu 22.04</b>
<br>
<br>
تعریف محدودیت برای اتصال همزمان به ازای هر کاربر :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/userlimit.sh --ipv4)
```
شامل چهار گزینه است :<br>
1 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر<br>
2 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس (Account expires توسط دستور chage یا usermod)<br>
3 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + تنظیم تاریخ انقضا برای کاربر بعد از اولین اتصال<br>
4 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس + تنظیم تاریخ انقضا برای کاربر بعد از اولین اتصال<br>
<br>
<br>
ساخت کاربر جدید به تعداد دلخواه :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/createuser.sh --ipv4)
```

<br>

```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/udpgw.sh --ipv4)
```
