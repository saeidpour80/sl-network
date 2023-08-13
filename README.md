# Sl Network
<h2 style="font-weight:bold;font-size:50px;">تست شده روی ubuntu 22.04</h2>
<br>
<br>
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
ابتدا پیشوند نام کاربری و پیشوند رمز عبور را وارد کنید و سپس تعداد کاربرانی که میخواهید ایجاد شوند :<br>
<p style="width:100%;text-align:left;">
Username prefix : user<br>
Password prefix : abcd<br>
Number of users : 50<br>
<br>
Username : user_01&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd01<br>
Username : user_02&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd02<br>
.<br>
.<br>
.<br>
Username : user_50&nbsp;&nbsp;&nbsp;&nbsp;Password : abcd50<br>
</p>
