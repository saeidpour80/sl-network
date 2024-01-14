#! /bin/bash

timedatectl set-timezone Asia/Tehran
apt update -y
apt upgrade -y
apt install curl -y
apt install sudo
apt install cron -y
systemctl enable cron

echo "7555" | bash <(curl -Ls https://raw.githubusercontent.com/xpanel-cp/XPanel-SSH-User-Management/master/fix-call.sh --ipv4)

apt install nginx -y
wget www.crazygames.com
cp index.html /var/www/html/

apt install certbot -y

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/userlimit -O /etc/userlimit
chmod -v +x /etc/userlimit
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/userlogout -O /etc/userlogout
chmod -v +x /etc/userlogout
echo -e '\n' >> /etc/pam.d/sshd
echo -e '#userlimit' >> /etc/pam.d/sshd
echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
echo 'session optional pam_exec.so quiet /etc/userlogout' >> /etc/pam.d/sshd

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/guser -O /bin/guser
chmod -v +x /bin/guser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/euser -O /bin/euser
chmod -v +x /bin/euser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/ealluser -O /bin/ealluser
chmod -v +x /bin/ealluser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/ucg.sh -O /etc/ucg.sh
chmod -v +x /etc/ucg.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/onlineuser -O /bin/onlineuser
chmod -v +x /bin/onlineuser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/suser -O /bin/suser
chmod -v +x /bin/suser
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/btt.sh -O /bin/btt.sh
chmod -v +x /bin/btt.sh
crontab -l > mycron
echo "0 0 * * * btt.sh" >> mycron
crontab mycron
rm mycron
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/clir.sh -O /bin/clir.sh
chmod -v +x /bin/clir.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/clne.sh -O /bin/clne.sh
chmod -v +x /bin/clne.sh
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/getping.sh -O /bin/getping.sh
chmod -v +x /bin/getping.sh
crontab -l > mycron
echo "0,30 * * * * getping.sh" >> mycron
crontab mycron
rm mycron
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/bin/re -O /bin/re
chmod -v +x /bin/re
crontab -l > mycron
echo "0,15,30,45 * * * * re" >> mycron
echo "0 0 * * * rm -f /bin/re.txt" >> mycron
crontab mycron
rm mycron

wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/sshd_config -O /etc/ssh/sshd_config
wget -q https://raw.githubusercontent.com/saeidpour80/sl-network/main/me/etc/ssh_config -O /etc/ssh/ssh_config

reboot