#! /bin/bash

echo '#! /bin/bash

limit=1
c=$(pgrep -xcu "$PAM_USER" sshd)
if [[ "$PAM_USER" != "root" ]] && [[ $c -ge $limit ]]
then
    pkill -u "$PAM_USER"
    exit 1
else
    exit 0
fi
' > /etc/userlimit

{ chmod -v +x /etc/userlimit; } &> /dev/null

echo -e '\n' >> /etc/pam.d/sshd

if  grep -Fxq "account    required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo 'account    required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi

if  grep -Fxq "auth       required     pam_exec.so /etc/userlimit" /etc/pam.d/sshd
then
    :
else
    echo 'auth       required     pam_exec.so /etc/userlimit' >> /etc/pam.d/sshd
fi


