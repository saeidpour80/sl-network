# Sl Network
:green_circle: <b>تست شده روی ubuntu 22.04</b>
<br>
<br>
### تعریف محدودیت برای اتصال همزمان به ازای هر کاربر :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/userlimit.sh --ipv4)
```
شامل چهار گزینه است :<br>
1 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر<br>
2 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس (Account expires توسط دستور chage یا usermod)<br>
3 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + تنظیم تاریخ انقضا برای کاربر بعد از اولین اتصال<br>
4 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس + تنظیم تاریخ انقضا برای کاربر بعد از اولین اتصال<br>
5 - تنظیم تاریخ انقضا برای کاربر بعد از اولین اتصال<br>
<br>
<br>
### ساخت کاربر جدید به تعداد دلخواه :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/createuser.sh --ipv4)
```
ابتدا پیشوند نام کاربری و پیشوند رمز عبور را وارد کنید و سپس تعداد کاربرانی که میخواهید ایجاد شوند :<br>
<p style="width:100%;text-align:left;">
Username prefix : user<br>
Password prefix : abcd<br>
Number of users : 50<br>
<br>
Username : user-1&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd1<br>
Username : user-2&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd2<br>
.<br>
.<br>
.<br>
Username : user-50&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd50<br>
</p>

<br>
<br>

### رفع مشکل تماس صوتی و تصویری در پروتکول SSH :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/udpgw.sh --ipv4)
```
