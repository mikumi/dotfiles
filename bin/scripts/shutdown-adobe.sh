#!/bin/sh

launchctl unload -w ~/Library/LaunchAgents/com.adobe.ccxprocess.plist
launchctl unload -w ~/Library/LaunchAgents/com.adobe.GC.Invoker-1.0.plist
launchctl unload -w /Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist
launchctl unload -w /Library/LaunchAgents/com.adobe.GC.AGM.plist
launchctl unload -w /Library/LaunchAgents/com.adobe.GC.Invoker-1.0.plist
launchctl unload -w /Library/LaunchDaemons/com.adobe.agsservice.plist
launchctl unload -w /Library/LaunchDaemons/com.adobe.acc.installer.v2.plist

launchctl stop com.adobe.AdobeCreativeCloud
launchctl stop com.adobe.GC.AGM
launchctl stop com.adobe.CCXProcess.6464
launchctl stop com.adobe.CCLibrary.6544
launchctl stop com.adobe.ccxprocess
launchctl stop com.adobe.accmac.28188
launchctl stop com.adobe.GC.Scheduler-1.0
launchctl stop com.adobe.accmac.6452
launchctl stop com.adobe.LightroomClassicCC7.30440

killall "AdobeRCDaemon"
killall "Adobe CCXProcess.app"
killall "Adobe Desktop Service"
killall "Adobe Installer"
killall "AdobeCRDaemon"
killall "AdobeIPCBroker"
killall "CCLibrary"
killall "CCXProcess"
killall "Core Sync"
killall "Core Sync Helper"
