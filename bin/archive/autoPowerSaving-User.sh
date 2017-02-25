#!/bin/sh

AC_POWER=`ioreg -l | grep ExternalConnected | cut -d"=" -f2 | sed -e 's/ //g'`

DROPBOX_APP_NAME="Dropbox.app"
CRASHPLAN_APP_NAME="CrashPlan menu bar.app"

YES=0 # Remeber exit code 0 is success. Don't think true=1/false=0
NO=1  # Remeber exit code != 0 is error. Don't think true=1/false=0

### FUNCTIONS ###

isAppRunning() {
    local appName="$1";
    local running=$NO;

    local checkIfLaunched=`ps -ax | grep "$appName" | grep -v grep | grep -o "$appName"`
    if [[ "$checkIfLaunched" == "$appName" ]]; then
        running=$YES; 
    else
        running=$NO; 
    fi
    return $running;
}

startApp() {
    local appName="$1"

    if ! isAppRunning "$appName"; then
        syslog -s -l notice "Starting $appName again...";
        open -a "$appName"
    fi
}

stopApp() {
    local appName="$1"

    if isAppRunning "$appName"; then
        syslog -s -l notice "Stopping $appName to save power...";
        cmd="osascript -e 'tell application \"$appName\" to quit'"
        eval $cmd
    fi
}

### MAIN START ###

if [[ "$AC_POWER" == "No" ]]
then
    #syslog -s -l notice "Battery...";
    stopApp "$DROPBOX_APP_NAME"
    stopApp "$CRASHPLAN_APP_NAME"
else
    #syslog -s -l notice "AC...";
    startApp "$DROPBOX_APP_NAME"
    startApp "$CRASHPLAN_APP_NAME"
fi


