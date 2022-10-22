#!/usr/bin/env osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Noise Cancellation
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon 🎧
# @raycast.author Michael Kuck
# @raycast.description Turns Noise Cancellation mode on or off.

tell application "System Events"
	tell application process "ControlCenter"
		try
			click menu bar item "Sound" of menu bar 1
			tell window 1
				UI elements
				tell scroll area 1
					if (value of checkbox "Noise Cancellation" as boolean) is false then
						click checkbox "Noise Cancellation"
					else
						click checkbox "Transparency"
					end if
				end tell
			end tell
			click menu bar item "Sound" of menu bar 1
		end try
	end tell
end tell
