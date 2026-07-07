#!/usr/bin/env osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Portal Toggle
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Ambient

# Documentation:
# @raycast.description Start or Stop Portal
# @raycast.author michaelk
# @raycast.authorURL https://raycast.com/michaelk

-- Remember the current frontmost app
tell application "System Events" to set previousApp to name of first application process whose frontmost is true

-- Launch Portal if needed
tell application "System Events" to set isRunning to (name of processes) contains "Portal"
if isRunning is false then
  tell application "Portal" to launch
  delay 0.8
end if

-- Bring Portal forward briefly
tell application "Portal" to activate
delay 0.05

-- Click Controls → Pause or Controls → Play (whichever exists)
tell application "System Events"
  tell application process "Portal"
    if exists menu item "Pause" of menu "Controls" of menu bar item "Controls" of menu bar 1 then
      click menu item "Pause" of menu "Controls" of menu bar item "Controls" of menu bar 1
    else if exists menu item "Play" of menu "Controls" of menu bar item "Controls" of menu bar 1 then
      click menu item "Play" of menu "Controls" of menu bar item "Controls" of menu bar 1
    else
      -- Fallback: spacebar if menu path changes
      keystroke space
    end if
  end tell
end tell

-- Return focus to the previous app
tell application previousApp to activate
