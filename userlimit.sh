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

