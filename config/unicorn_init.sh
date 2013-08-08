#!/bin/sh
#
### BEGIN INIT INFO
# Provides:          unicorn_pinstopaper
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Unicorn process for PinsToPaper
# Description:       Unicorn server serving the PinsToPaper app
### END INIT INFO

set -e

# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}

USER=matt
APP_ROOT=/opt/pinstopaper/current

PID=/tmp/unicorn.pinstopaper.pid
CMD="cd $APP_ROOT; bundle exec unicorn -D -c $APP_ROOT/config/unicorn.rb -E production"
action="$1"

set -u

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
    test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
    test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
status)
    if [ -f /tmp/unicorn.pinstopaper.pid ]; then
        echo "Server running"
    else
        echo "PID not found"
    fi
    ;;
start)
    sig 0 && echo >&2 "Already running" && exit 0
    su -c "$CMD" - $USER
    ;;
stop)
    sig QUIT && exit 0
    echo >&2 "Not running"
    ;;
force-stop)
    sig TERM && exit 0
    echo >&2 "Not running"
    ;;
restart|reload)
    sig HUP && echo reloaded OK && exit 0
    echo >&2 "Couldn't reload, starting '$CMD' instead"
    su -c "$CMD" - $USER
    ;;
upgrade)
    if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
    then
        n=$TIMEOUT
        while test -s $old_pid && test $n -ge 0
        do
            printf '.' && sleep 1 && n=$(( $n - 1 ))
        done
        echo

        if test $n -lt 0 && test -s $old_pid
        then
            echo >&2 "$old_pid still exists after $TIMEOUT seconds"
            exit 1
        fi
        exit 0
    fi
    echo >&2 "Couldn't upgrade, starting '$CMD' instead"
    su -c "$CMD" - $USER
    ;;
reopen-logs)
    sig USR1
    ;;
*)
    echo >&2 "Usage: $0 <start|stop|restart|upgrade|force-stop|reopen-logs>"
    exit 1
    ;;
esac

