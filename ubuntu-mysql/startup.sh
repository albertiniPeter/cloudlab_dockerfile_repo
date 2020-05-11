#! /bin/bash
set -e

## fix network config
if [ -d "/root/dockerstartup/networkbackup/" ]; then
    cat /root/dockerstartup/networkbackup/hosts > /etc/hosts
    cat /root/dockerstartup/networkbackup/hostname > /etc/hostname
    cat /root/dockerstartup/networkbackup/resolv.conf > /etc/resolv.conf
fi

ENABLE_SSH=${ENABLE_SSH:-true}
ENABLE_VNC=${ENABLE_VNC:-true}

SSH_CONF=/etc/supervisor/conf.d/sshd.conf

# start ssh
if [[ "$ENABLE_SSH" == "true" ]] ; then
    if [ ! -f $SSH_CONF ] ; then
        cp /root/dockerstartup/modes/sshd.conf /etc/supervisor/conf.d/
    fi
fi

# start vnc server
if [[ "$ENABLE_VNC" == "true" ]] ; then
    ## change vnc password
    echo -e "\n------------------ change VNC password  ------------------"
    # first entry is control, second is view (if only one is valid for both)
    mkdir -p "$HOME/.vnc"
    PASSWD_PATH="$HOME/.vnc/passwd"

    if [[ -f $PASSWD_PATH ]]; then
        echo -e "\n---------  purging existing VNC password settings  ---------"
        rm -f $PASSWD_PATH
    fi

    echo "$VNC_PW" | vncpasswd -f >> $PASSWD_PATH
    chmod 600 $PASSWD_PATH

    echo -e "\n------------------ start VNC server ------------------------"
    echo "remove old vnc locks to be a reattachable container"
    vncserver -kill :1 \
        || rm -rfv /tmp/.X*-lock /tmp/.X11-unix \
        || echo "no locks present"
    vncserver -geometry ${WIDTH:-1152}x${HEIGHT-864} :1 securitytypes=none
fi

MYSQL_ROOT_PWD=${MYSQL_ROOT_PWD:-"root"}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_USER_PWD=${MYSQL_USER_PWD:-""}
MYSQL_USER_DB=${MYSQL_USER_DB:-"hive"}

echo "[i] Setting up new power user credentials."
service mysql start $ sleep 10

echo "[i] Setting root new password."
mysql --user=root --password=root -e "UPDATE mysql.user set authentication_string=password('$MYSQL_ROOT_PWD') where user='root'; FLUSH PRIVILEGES;"

echo "[i] Setting root remote password."
mysql --user=root --password=$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PWD' WITH GRANT OPTION; FLUSH PRIVILEGES;"

if [ -n "$MYSQL_USER_DB" ]; then
	echo "[i] Creating datebase: $MYSQL_USER_DB"
	mysql --user=root --password=$MYSQL_ROOT_PWD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_USER_DB\` CHARACTER SET utf8 COLLATE utf8_general_ci; FLUSH PRIVILEGES;"

	if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_USER_PWD" ]; then
		echo "[i] Create new User: $MYSQL_USER with password $MYSQL_USER_PWD for new database $MYSQL_USER_DB."
		mysql --user=root --password=$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON \`$MYSQL_USER_DB\`.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	else
		echo "[i] Don\`t need to create new User."
	fi
else
	if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_USER_PWD" ]; then
		echo "[i] Create new User: $MYSQL_USER with password $MYSQL_USER_PWD for all database."
		mysql --user=root --password=$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PWD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
	else
		echo "[i] Don\`t need to create new User."
	fi
fi

killall mysqld
sleep 5
echo "[i] Setting end,have fun."

exec /usr/bin/mysqld_safe &

#start supervisor
_term() {
    while kill -0 $child >/dev/null 2>&1
    do
        kill -TERM $child 2>/dev/null
    done
}

trap _term 15 9
exec /usr/bin/supervisord -n &
child=$!
wait $child