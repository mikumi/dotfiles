#!/bin/sh

AC_POWER=`ioreg -l | grep ExternalConnected | cut -d"=" -f2 | sed -e 's/ //g'`

CRASHPLAN_SERVICE_NAME=com.crashplan.engine

YES=0 # Remeber exit code 0 is success. Don't think true=1/false=0
NO=1  # Remeber exit code != 0 is error. Don't think true=1/false=0

### FUNCTIONS ###

isServiceRunning() {
	local serviceName="$1";
	local running=$NO;

	local checkIfLaunched=`sudo launchctl list | grep -o $serviceName`;	
	if [[ "$checkIfLaunched" == "$serviceName" ]]; then
		running=$YES; 
	else
		running=$NO; 
	fi
	return $running;
}

### START MAIN ###

if [[ "$AC_POWER" == "No" ]]
then
	#syslog -s -l notice "Battery...";
    if isServiceRunning "$CRASHPLAN_SERVICE_NAME"; then
    	syslog -s -l notice "Stopping $CRASHPLAN_SERVICE_NAME to save power...";
    	sudo launchctl unload /Library/LaunchDaemons/com.crashplan.engine.plist
    fi
else
	#syslog -s -l notice "AC...";
    if ! isServiceRunning "$CRASHPLAN_SERVICE_NAME"; then
    	syslog -s -l notice "Starting $CRASHPLAN_SERVICE_NAME again...";
    	sudo launchctl load -w /Library/LaunchDaemons/com.crashplan.engine.plist
    fi
fi
