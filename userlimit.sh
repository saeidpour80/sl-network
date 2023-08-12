echo '
#! /bin/bash

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

sed 'account    required     pam_exec.so /etc/userlimit\nauth       required     pam_exec.so /etc/userlimit /^s# Standard Un*x password updating..*/a' /etc/pam.d/sshd
