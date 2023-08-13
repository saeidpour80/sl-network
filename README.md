# Sl Network

تعریف محدودیت برای اتصال همزمان به ازای هر کاربر :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/userlimit.sh --ipv4)
```
شامل دو گزینه است :<br>
1 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر<br>
2 - اعمال محدودیت روی تعداد اتصال همزمان به ازای هر کاربر + مسدود کردن کاربر سر ساعت 12 شب به وقت ایران متناسب با تاریخ انقضا تعریف شده در لینوکس (Account expires توسط دستور chage یا usermod)<br>
<br>
<br>
ساخت کاربر جدید به تعداد دلخواه :
```
bash <(curl -Ls https://raw.githubusercontent.com/saeidpour80/sl-network/master/createuser.sh --ipv4)
```
ابتدا پیشوند نام کاربری و پیشوند رمز عبور را وارد میکنید و سپس تعداد کاربرانی که میخوایید ایجاد شوند :<br>
Username prefix : user<br>
Password prefix : abcd<br>
Number of users : 50<br>
<br>
Username : user_01  Password : abcd01<br>
Username : user_02  Password : abcd02<br>
.<br>
.<br>
.<br>
Username : user_50  Password : abcd50<br>
